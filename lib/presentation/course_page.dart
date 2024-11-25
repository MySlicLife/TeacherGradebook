import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_gradebook/helpers/update_checker/update_checker.dart';
import 'package:teacher_gradebook/presentation/course_overview_page.dart';
import 'package:teacher_gradebook/presentation/welcome_page.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/course_day_selector.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/icon_button.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/text_button.dart';
import 'package:teacher_gradebook/presentation/widgets/drawers/settings_drawer.dart';
import 'package:teacher_gradebook/presentation/widgets/text_field/text_field.dart';
import 'package:teacher_gradebook/storage/course/course_cubit.dart';
import 'package:teacher_gradebook/storage/settings/settings_storage.dart';
import 'package:statistics/statistics.dart';

import '../modules/dialog/color_picker_dialog.dart';
import '../storage/assignment/assignment_cubit.dart';
import '../storage/course/course.dart';
import '../storage/grade/grade_cubit.dart';
import '../storage/school_year/year.dart';
import '../storage/school_year/year_cubit.dart';
import '../storage/student/student.dart';
import '../storage/student/student_cubit.dart';
import '../storage/teacher_repo.dart';
import 'theme/colors.dart';
import 'theme/theme_cubit.dart';
import 'widgets/misc/grade_breakdown.dart';

class CoursePage extends StatefulWidget {
  Year currentYear;

  CoursePage({super.key, required this.currentYear});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  double elementPadding = 25;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final List<Course> aCourses = [];
  final List<Course> bCourses = [];
  late Map<String, dynamic> selectedItemStatistics = {};
  bool colorChanged = false;
  bool courseChanged = false;
  String? selectedDay;
  bool addCourse = false;
  Course? selectedCourse;

  @override
  void initState() {
    super.initState();
    categorizeCourses(widget.currentYear, null);
    context.read<CourseCubit>().loadCourses(widget.currentYear.id);
  }

  //Go to last page
  void goToPreviousPage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
              BlocProvider(create: (context) => YearCubit(TeacherRepo())),
              BlocProvider.value(value: context.read<ThemeCubit>()),
              BlocProvider.value(value: context.read<SettingsCubit>()),
            ], child: MaterialApp(home: WelcomePage()))));
  }

  // Get the current theme for the selected year
  ThemeData getCurrentTheme(
      int yearColorId, ThemeCubit themeCubit, SettingsState settingsState) {
    var theme = themeCubit.colorThemes.firstWhere(
      (theme) => theme.colorThemeId == yearColorId,
    );
    return settingsState.isDarkMode ? theme.darkMode : theme.lightMode;
  }

  //Open the color picker
  Future<void> _openColorPicker(Year? year, SettingsCubit settingsCubit) async {
    int? colorPickerResult = await showDialog<int>(
      context: context,
      builder: (context) => ColorPickerDialog(
        availableColors: AvailableColors.colors,
        yearColorId: year?.yearColorId ?? settingsCubit.state.appThemeInt,
      ),
    );
    if (colorPickerResult != null) {
      if (year != null) {
        setState(() {
          if (year.yearColorId != colorPickerResult) {
            colorChanged = true;
            widget.currentYear.yearColorId = colorPickerResult;
          }
        });
      } else {
        settingsCubit.updateAppColor(colorPickerResult);
      }
    }
  }

  //Develop the list of courses
  void categorizeCourses(Year year, List<Course>? courses) {
    aCourses.clear();
    bCourses.clear();
    for (var course in courses ?? year.courses) {
      if (course.coursePeriod.contains("A")) {
        aCourses.add(course);
      } else if (course.coursePeriod.contains("B")) {
        bCourses.add(course);
      } else {
        Logger.logMessage(
            "Unable to categorize course ${course.courseName} | ${course.coursePeriod}");
      }
    }

    Logger.logMessage("Successfully categorized all courses");
  }

  //Go to the assignment page
  void navigateToAssignmentView(BuildContext context, Course selectedCourse) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
              BlocProvider.value(value: context.read<ThemeCubit>()),
              BlocProvider.value(value: context.read<SettingsCubit>()),
              BlocProvider(create: (context) => AssignmentCubit(TeacherRepo())),
              BlocProvider(create: (context) => StudentCubit(TeacherRepo())),
              BlocProvider(create: (context) => GradeCubit(TeacherRepo())),
            ], child: CourseOverviewPage(selectedCourse: selectedCourse))));
  }

  //Calculate grade statistics
  void calculateStatistic(Course selectedCourse) {
    List<double> gradeList = [];
    List<Student> studentList = [];

    for (var student in selectedCourse.students) {
      studentList.add(student);
      if (student.studentNumberGrade != null) {
        gradeList.add(student.studentNumberGrade!);
      }
    }

    // Handle empty grade list case
    if (gradeList.isEmpty) {
      setState(() {
        selectedItemStatistics = {
          'max': {'student': '', 'period': '', 'grade': ''},
          'min': {'student': '', 'period': '', 'grade': ''},
          'avg': '',
          'sd': '',
        };
      });
      return;
    }

    // Calculate grade statistics
    var statisticGradeList = gradeList.statistics;
    Map<String, dynamic> statistics = {};

    // Max Grade
    Student highestStudent = studentList.firstWhere(
        (student) => student.studentNumberGrade == statisticGradeList.max);
    statistics['max'] = {
      'student': highestStudent.studentName,
      'grade': highestStudent.studentNumberGrade
    };

    // Min Grade
    Student lowestStudent = studentList.firstWhere(
        (student) => student.studentNumberGrade == statisticGradeList.min);
    statistics['min'] = {
      'student': lowestStudent.studentName,
      'grade': lowestStudent.studentNumberGrade
    };

    // Average Grade (Mean)
    statistics["avg"] = statisticGradeList.mean.toString();

    // Standard Deviation Grade
    statistics["sd"] = statisticGradeList.standardDeviation.toString();

    setState(() {
      selectedItemStatistics = statistics;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final themeCubit = context.read<ThemeCubit>();
    final courseCubit = context.read<CourseCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        nameController.text = settingsCubit.state.teacherName;
        return BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, appTheme) {
            final ThemeData coursePageTheme = getCurrentTheme(
                widget.currentYear.yearColorId, themeCubit, settingsState);
            return BlocBuilder<CourseCubit, CourseState>(
              builder: (context, courseState) {
                if (courseState is CourseLoaded) {
                  categorizeCourses(widget.currentYear, courseState.courses);
                } else if (courseState is CourseInitial) {
                  categorizeCourses(widget.currentYear, null);
                }
                return Scaffold(
                    key: _scaffoldKey,
                    endDrawer: SettingsDrawer(
                        screenTheme: appTheme,
                        themeCubit: themeCubit,
                        settingsCubit: settingsCubit,
                        nameController: nameController,
                        onTap: () => _openColorPicker(null, settingsCubit)),
                    backgroundColor: coursePageTheme.colorScheme.surface,
                    body: Padding(
                      padding: EdgeInsets.all(elementPadding),
                      child: Row(
                        children: [
                          //Row left is information text and course selection buttons
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: elementPadding / 2),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //First is Year and Back Button
                                  Flexible(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Back Button
                                        Container(
                                          decoration: BoxDecoration(
                                              color: coursePageTheme
                                                  .colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: NeumorphicIconButton(
                                                    onPressed: () =>
                                                        goToPreviousPage(
                                                            context),
                                                    currentTheme:
                                                        coursePageTheme,
                                                    buttonIcon: Icons
                                                        .arrow_back_ios_new_rounded),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: coursePageTheme
                                                    .colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                                child: Text(
                                              widget.currentYear.year,
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 90),
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //Second is Date Range
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: coursePageTheme
                                                .colorScheme.primary,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              DateFormat('MMMM dd, yyyy')
                                                  .format(widget
                                                      .currentYear.startDate),
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40),
                                            ),
                                            Text(
                                              "-",
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat('MMMM dd, yyyy')
                                                  .format(widget
                                                      .currentYear.endDate),
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40),
                                            ),
                                          ],
                                        ),
                                      )),
                                  //Third is School and Location
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: coursePageTheme
                                                .colorScheme.primary,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              widget.currentYear.schoolName,
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.currentYear.location,
                                              style: TextStyle(
                                                  color: coursePageTheme
                                                      .colorScheme.onPrimary,
                                                  fontSize: 40),
                                            ),
                                          ],
                                        ),
                                      )),
                                  //Fourth is row of A day and B day

                                  if (courseState is CourseLoaded)
                                    Flexible(
                                        flex: 15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: coursePageTheme
                                                  .colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            children: [
                                              //A day
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "A Day",
                                                      style: TextStyle(
                                                          color: coursePageTheme
                                                              .colorScheme
                                                              .onPrimary,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (aCourses.isNotEmpty)
                                                      Expanded(
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            double
                                                                availableHeight =
                                                                constraints
                                                                        .maxHeight -
                                                                    (4 *
                                                                        elementPadding);
                                                            double
                                                                buttonHeight =
                                                                availableHeight /
                                                                    4;
                                                            return ListView
                                                                .builder(
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        aCourses
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.all(elementPadding /
                                                                                2),
                                                                        child: SizedBox(
                                                                            height: buttonHeight,
                                                                            child: NeumorphicTextButton(
                                                                              buttonText: "${aCourses[index].coursePeriod} | ${aCourses[index].courseName}",
                                                                              onPressed: () {
                                                                                calculateStatistic(aCourses[index]);
                                                                                setState(() {
                                                                                  selectedCourse = aCourses[index];
                                                                                  courseNameController.text = aCourses[index].courseName;
                                                                                  periodController.text = aCourses[index].coursePeriod.replaceAll(RegExp(r'[a-zA-Z]'), '');
                                                                                  addCourse = false;
                                                                                });
                                                                              },
                                                                              screenTheme: coursePageTheme,
                                                                              buttonTextSize: 40,
                                                                            )),
                                                                      );
                                                                    });
                                                          },
                                                        ),
                                                      )
                                                    else if (aCourses.isEmpty)
                                                      Text(
                                                        "No A Day Courses...",
                                                        style: TextStyle(
                                                            color:
                                                                coursePageTheme
                                                                    .colorScheme
                                                                    .onPrimary,
                                                            fontSize: 60,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              //B day
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "B Day",
                                                      style: TextStyle(
                                                          color: coursePageTheme
                                                              .colorScheme
                                                              .onPrimary,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (bCourses.isNotEmpty)
                                                      Expanded(
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            double
                                                                availableHeight =
                                                                constraints
                                                                        .maxHeight -
                                                                    (4 *
                                                                        elementPadding);
                                                            double
                                                                buttonHeight =
                                                                availableHeight /
                                                                    4;
                                                            return ListView
                                                                .builder(
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        bCourses
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.all(elementPadding /
                                                                                2),
                                                                        child: SizedBox(
                                                                            height: buttonHeight,
                                                                            child: NeumorphicTextButton(
                                                                              buttonText: "${bCourses[index].coursePeriod} | ${bCourses[index].courseName}",
                                                                              onPressed: () {
                                                                                calculateStatistic(bCourses[index]);
                                                                                setState(() {
                                                                                  selectedCourse = bCourses[index];
                                                                                  courseNameController.text = bCourses[index].courseName;
                                                                                  periodController.text = aCourses[index].coursePeriod.replaceAll(RegExp(r'[a-zA-Z]'), '');
                                                                                  addCourse = false;
                                                                                });
                                                                              },
                                                                              screenTheme: coursePageTheme,
                                                                              buttonTextSize: 40,
                                                                            )),
                                                                      );
                                                                    });
                                                          },
                                                        ),
                                                      )
                                                    else if (bCourses.isEmpty)
                                                      Text(
                                                        "No B Day Courses...",
                                                        style: TextStyle(
                                                            color:
                                                                coursePageTheme
                                                                    .colorScheme
                                                                    .onPrimary),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                ],
                              ),
                            ),
                          ),
                          //Row right is add course, settings and the text box for the course
                          Expanded(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: elementPadding / 2),
                                  child: Column(children: [
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          //First is Add Course and Settings Button
                                          Flexible(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: elementPadding / 2),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Add year button (4x the width of the Settings button)
                                                    Flexible(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 20),
                                                        child:
                                                            NeumorphicTextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              addCourse = true;
                                                              selectedCourse =
                                                                  null;
                                                              courseNameController
                                                                  .clear();
                                                              periodController
                                                                  .clear();
                                                            });
                                                          },
                                                          buttonText:
                                                              "Add Course...",
                                                          screenTheme:
                                                              coursePageTheme,
                                                        ),
                                                      ),
                                                    ),

                                                    // Settings button (perfect square)
                                                    Flexible(
                                                      flex: 2,
                                                      child: AspectRatio(
                                                        aspectRatio:
                                                            1, // Ensures the button is a perfect square
                                                        child:
                                                            NeumorphicIconButton(
                                                          onPressed: () {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .openEndDrawer();
                                                          },
                                                          buttonIcon:
                                                              Icons.settings,
                                                          currentTheme:
                                                              appTheme,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          //Second is the course textbox
                                          if (selectedCourse != null ||
                                              addCourse == true)
                                            Expanded(
                                                flex: 22,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      elementPadding / 2),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: coursePageTheme
                                                            .colorScheme
                                                            .primary),
                                                    child: Column(
                                                      children: [
                                                        //Row that contains the course name text box, period text box and A or B button selector
                                                        Flexible(
                                                            flex: 4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                //Text field and period identifier
                                                                Flexible(
                                                                  flex: 4,
                                                                  child: Row(
                                                                    children: [
                                                                      // Course text field
                                                                      Flexible(
                                                                        flex: 3,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 10,
                                                                              bottom: 10,
                                                                              left: 10),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(15),
                                                                                bottomLeft: Radius.circular(15),
                                                                              ),
                                                                              color: coursePageTheme.colorScheme.tertiary,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: TextField(
                                                                                cursorColor: coursePageTheme.colorScheme.onTertiary,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontSize: 50,
                                                                                  color: coursePageTheme.colorScheme.onTertiary,
                                                                                ),
                                                                                controller: courseNameController,
                                                                                decoration: InputDecoration(
                                                                                  border: InputBorder.none,
                                                                                  hintText: 'Course Name',
                                                                                  hintStyle: TextStyle(color: coursePageTheme.colorScheme.onTertiary),
                                                                                ),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    courseChanged = true;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Period Textbox
                                                                      Flexible(
                                                                        flex:
                                                                            1, // Same flex value as the text field container
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 10,
                                                                              bottom: 10,
                                                                              right: 10),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(15),
                                                                                bottomRight: Radius.circular(15),
                                                                              ),
                                                                              color: coursePageTheme.colorScheme.tertiary,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                selectedCourse?.coursePeriod ?? "Period",
                                                                                style: TextStyle(
                                                                                  color: coursePageTheme.colorScheme.onTertiary,
                                                                                  fontSize: 50, // Adjust the font size as needed
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                    flex: 2,
                                                                    child:
                                                                        SizedBox()),
                                                                Expanded(
                                                                    flex: 2,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        //Text field for period number
                                                                        Flexible(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  color: coursePageTheme.colorScheme.tertiary,
                                                                                ),
                                                                                child: Center(
                                                                                  child: TextField(
                                                                                    onChanged: (value) {
                                                                                      setState(() {
                                                                                        courseChanged = true;
                                                                                        if (addCourse == false) {
                                                                                          selectedCourse!.coursePeriod = "${value}${selectedCourse!.coursePeriod.replaceAll(RegExp(r'\d'), '')}";
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    cursorColor: coursePageTheme.colorScheme.onTertiary,
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontSize: 50, color: coursePageTheme.colorScheme.onTertiary),
                                                                                    controller: periodController,
                                                                                    inputFormatters: [
                                                                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                                                                                    ],
                                                                                    decoration: InputDecoration(
                                                                                      border: InputBorder.none,
                                                                                      hintStyle: TextStyle(color: coursePageTheme.colorScheme.onTertiary),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        //Button selector for A or B day
                                                                        Flexible(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                CourseDaySelector(
                                                                              isA: selectedCourse?.coursePeriod.contains('A') ?? false,
                                                                              courseTheme: coursePageTheme,
                                                                              isDarkMode: settingsState.isDarkMode,
                                                                              onPeriodSelected: (selectedPeriod) {
                                                                                setState(() {
                                                                                  selectedDay = selectedPeriod;
                                                                                  selectedCourse!.coursePeriod = "${selectedCourse!.coursePeriod.replaceAll(RegExp(r'[a-zA-Z]'), '')}${selectedPeriod}";
                                                                                });
                                                                              },
                                                                            ))
                                                                      ],
                                                                    )),
                                                              ],
                                                            )),
                                                        //Row that contains left stats, divider and right stats
                                                        Flexible(
                                                            flex: 16,
                                                            child: Row(
                                                              children: [
                                                                //Left side is number of students, grade breakdown
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Flexible(
                                                                          flex:
                                                                              2,
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: coursePageTheme.colorScheme.secondary),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "Total Students: ",
                                                                                        style: TextStyle(fontSize: 25, color: coursePageTheme.colorScheme.onSecondary),
                                                                                      ),
                                                                                      SizedBox(width: 10),
                                                                                      Text(
                                                                                        selectedCourse?.students.length.toString() ?? "25",
                                                                                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coursePageTheme.colorScheme.onSecondary),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ),
                                                                        Flexible(
                                                                          flex:
                                                                              10,
                                                                          child:
                                                                              GradeBreakdown(
                                                                            selectedCourse:
                                                                                selectedCourse,
                                                                            screenTheme:
                                                                                coursePageTheme,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                //Vertical divider
                                                                VerticalDivider(
                                                                  thickness: 2,
                                                                  color: coursePageTheme
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                  width: 20,
                                                                ),
                                                                //Right side is statistics
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            color:
                                                                                coursePageTheme.colorScheme.secondary,
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Container(
                                                                                    padding: EdgeInsets.all(5),                                                                            decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    color: coursePageTheme.colorScheme.primary,),
                                                                                  child: Text("Statistics", style: TextStyle(color: Colors.white, fontSize: 40),),),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(5),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    color: coursePageTheme.colorScheme.primary,
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Text(
                                                                                        addCourse ? 'Bob Bobbington' : "${selectedItemStatistics['max']['student']}",
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(color: coursePageTheme.colorScheme.onPrimary, fontSize: 40, overflow: TextOverflow.fade),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: Text(
                                                                                          addCourse ? '100' : "${selectedItemStatistics['max']['grade']}",
                                                                                          style: TextStyle(
                                                                                            color: coursePageTheme.colorScheme.onPrimary,
                                                                                            fontSize: 30,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: Text(
                                                                                          "Highest Grade",
                                                                                          style: TextStyle(
                                                                                            color: coursePageTheme.colorScheme.onPrimary,
                                                                                            fontSize: 20,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(5),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    color: coursePageTheme.colorScheme.primary,
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Text(
                                                                                        addCourse ? 'Bob Bobbington' : "${selectedItemStatistics['min']['student']}",
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(color: coursePageTheme.colorScheme.onPrimary, fontSize: 40, overflow: TextOverflow.fade),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: Text(
                                                                                          addCourse ? '100' : "${selectedItemStatistics['min']['grade']}",
                                                                                          style: TextStyle(
                                                                                            color: coursePageTheme.colorScheme.onPrimary,
                                                                                            fontSize: 30,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: Text(
                                                                                          "Lowest Grade",
                                                                                          style: TextStyle(
                                                                                            color: coursePageTheme.colorScheme.onPrimary,
                                                                                            fontSize: 20,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    //Average Grade
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(right: 5),
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(5),
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            color: coursePageTheme.colorScheme.primary,
                                                                                          ),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Average", style: TextStyle(color: Colors.white, fontSize: 18)),
                                                                                              Text(selectedItemStatistics['avg'])
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    //Standard Deviation Grade
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 5),
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(5),
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                            color: coursePageTheme.colorScheme.primary,
                                                                                          ),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text("Standard Deviation", style: TextStyle(color: Colors.white, fontSize: 18),),
                                                                                              Text(selectedItemStatistics['sd'])
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                        //Row that contains delete button, save changes, and navigate button
                                                        Flexible(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  //Delete course
                                                                  Flexible(
                                                                    flex: 2,
                                                                    child:
                                                                        NeumorphicTextButton(
                                                                      buttonText:
                                                                          "Delete",
                                                                      onPressed:
                                                                          () {
                                                                        if (addCourse ==
                                                                            true) {
                                                                          addCourse ==
                                                                              false;
                                                                        } else {
                                                                          courseCubit.deleteCourse(
                                                                              selectedCourse!.courseId,
                                                                              widget.currentYear.id);
                                                                        }
                                                                      },
                                                                      screenTheme:
                                                                          coursePageTheme,
                                                                      buttonColor: coursePageTheme
                                                                          .colorScheme
                                                                          .error,
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                      flex: 3,
                                                                      child:
                                                                          SizedBox()),
                                                                  if (addCourse ==
                                                                      true)
                                                                    Flexible(
                                                                        flex: 5,
                                                                        child: NeumorphicTextButton(
                                                                            buttonText: "Add Course",
                                                                            onPressed: () {
                                                                              if (courseState is CourseLoaded) {
                                                                                if (courseState.courses.any((course) => course.coursePeriod != periodController.text)) {
                                                                                  courseCubit.addCourse(courseNameController.text, selectedCourse!.coursePeriod, widget.currentYear.id, []);
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    content: Text("This course already exists..", style: TextStyle(color: coursePageTheme.colorScheme.onError)),
                                                                                    backgroundColor: coursePageTheme.colorScheme.error,
                                                                                    duration: Duration(seconds: 3),
                                                                                  ));
                                                                                }
                                                                                addCourse = false;
                                                                                courseNameController.clear();
                                                                                periodController.clear();
                                                                              }
                                                                            },
                                                                            screenTheme: coursePageTheme)),
                                                                  if (addCourse ==
                                                                      false)
                                                                    Flexible(
                                                                      flex: 5,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          if ((colorChanged == true ||
                                                                              courseChanged == true))
                                                                            Flexible(
                                                                                flex: 2,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(right: 25),
                                                                                  child: NeumorphicTextButton(
                                                                                    buttonText: "Save Changes",
                                                                                    onPressed: () {
                                                                                      if (courseState is CourseLoaded) {
                                                                                        bool courseExists = courseState.courses.any((course) => course.coursePeriod != periodController.text && course.courseId != selectedCourse!.courseId);

                                                                                        if (!courseExists || selectedCourse!.coursePeriod == periodController.text) {
                                                                                          courseCubit.editCourse(selectedCourse!.courseId, widget.currentYear.id, courseNameController.text, selectedCourse!.coursePeriod, []);
                                                                                        } else {
                                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                            content: Text("This course already exists..", style: TextStyle(color: coursePageTheme.colorScheme.onError)),
                                                                                            backgroundColor: coursePageTheme.colorScheme.error,
                                                                                            duration: Duration(seconds: 3),
                                                                                          ));
                                                                                        }
                                                                                        colorChanged = false;
                                                                                        courseChanged = false;
                                                                                      }
                                                                                    },
                                                                                    screenTheme: coursePageTheme,
                                                                                    buttonTextSize: 15,
                                                                                  ),
                                                                                )),
                                                                          //Navigate
                                                                          if ((colorChanged == false &&
                                                                              courseChanged == false))
                                                                            Flexible(
                                                                                flex: 2,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(right: 25),
                                                                                  child: Container(),
                                                                                )),
                                                                          Flexible(
                                                                              flex: 4,
                                                                              child: NeumorphicTextButton(
                                                                                  buttonText: "Navigate",
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                                      builder: (context) => MultiBlocProvider(
                                                                                        providers: [
                                                                                          BlocProvider.value(value: context.read<ThemeCubit>()),
                                                                                          BlocProvider.value(value: context.read<SettingsCubit>()),
                                                                                          BlocProvider(create: (context) => AssignmentCubit(TeacherRepo())),
                                                                                          BlocProvider(create: (context) => StudentCubit(TeacherRepo())),
                                                                                          BlocProvider(create: (context) => GradeCubit(TeacherRepo())),
                                                                                        ],
                                                                                        child: CoursePage(currentYear: widget.currentYear)
                                                                                        
                                                                                        //CourseOverviewPage(selectedCourse: selectedCourse!),
                                                                                      ),
                                                                                    ));
                                                                                  },
                                                                                  screenTheme: coursePageTheme))
                                                                        ],
                                                                      ),
                                                                    )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          if (selectedCourse == null)
                                            Flexible(
                                                flex: 22, child: Container())
                                        ],
                                      ),
                                    ),
                                  ]))),
                        ],
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }
}
