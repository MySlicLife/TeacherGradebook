import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_gradebook/modules/dialog/course_dialog.dart';
import 'package:teacher_gradebook/presentation/course_page.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/icon_button.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/text_button.dart';
import 'package:teacher_gradebook/presentation/widgets/drawers/settings_drawer.dart';
import 'package:teacher_gradebook/presentation/widgets/radio/year_page_class_radio.dart';
import 'package:teacher_gradebook/presentation/widgets/text_field/text_field.dart';
import 'package:teacher_gradebook/storage/assignment/assignment_cubit.dart';
import 'package:teacher_gradebook/storage/course/course_cubit.dart';
import 'package:teacher_gradebook/storage/grade/grade_cubit.dart';
import 'package:teacher_gradebook/storage/settings/settings_storage.dart';
import 'package:teacher_gradebook/storage/student/student.dart';
import 'package:teacher_gradebook/storage/student/student_cubit.dart';
import 'package:teacher_gradebook/storage/teacher_repo.dart';
import 'package:statistics/statistics.dart';

import '../modules/dialog/color_picker_dialog.dart';
import '../storage/course/course.dart';
import '../storage/school_year/year.dart';
import '../storage/school_year/year_cubit.dart';
import 'theme/colors.dart';
import 'theme/theme_cubit.dart';
import 'widgets/misc/grade_breakdown.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<Year>> groupedYears = {};
  late Year? selectedYear;
  late ThemeData? selectedYearTheme;
  late List<Course>? selectedCourseList;
  late Map<String, dynamic> selectedItemStatistics = {};
  late int? selectedYearColor;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();

  bool addYear = false;
  bool colorChanged = false;
  bool textChanged = false;
  int? addYearColor;
  double elementPadding = 25;

  final yearTextController = TextEditingController();
  final schoolNameController = TextEditingController();
  final locationController = TextEditingController();
  int _selectedTabIndex = 0;
  final dummyCourses = [
    Course(courseName: "Test 1", coursePeriod: "", thresholds: []),
    Course(courseName: "Test 2", coursePeriod: "", thresholds: []),
    Course(courseName: "Test 3", coursePeriod: "", thresholds: []),
    Course(courseName: "Test 4", coursePeriod: "", thresholds: []),
    Course(courseName: "Test 5", coursePeriod: "", thresholds: []),
  ];

  @override
  void initState() {
    super.initState();
    context.read<YearCubit>().loadYears(); // Load all the years from the year cubit
    selectedYear = null;
    selectedYearTheme = null;
    selectedCourseList = null;
    selectedYearColor = null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    yearTextController.dispose();
    super.dispose();
  }

  // Group years by decade
  Map<String, List<Year>> groupYearsByDecade(List<Year> years) {
    years.sort((a, b) => a.year.compareTo(b.year)); // Sort years
    Map<String, List<Year>> groupedYears = {};
    for (var year in years) {
      String key =
          '${year.year.toString().substring(0, 3)}0s'; // Example: 2020s
      if (!groupedYears.containsKey(key)) {
        groupedYears[key] = [];
      }
      groupedYears[key]!.add(year);
    }
    return groupedYears;
  }

  // Initialize the TabController for the grouped years
  void _initializeTabController(List<Year> years) {
    groupedYears = groupYearsByDecade(years);

    if (groupedYears.isNotEmpty) {
      _tabController = TabController(
        length: groupedYears.keys.length,
        vsync: this,
        initialIndex: _selectedTabIndex.clamp(0, groupedYears.keys.length - 1),
      )..addListener(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedTabIndex =
                  _tabController.index; // Update the selected tab index
            });
          });
        });
    } else {
      _tabController.dispose(); // Dispose the controller if there are no years
    }
  }

  // Get the current theme for the selected year
  ThemeData getCurrentTheme(int yearColorId, ThemeCubit themeCubit, SettingsState settingsState) {
    var theme = themeCubit.colorThemes.firstWhere(
      (theme) => theme.colorThemeId == yearColorId,
    );
    return settingsState.isDarkMode ? theme.darkMode : theme.lightMode;
  }

  // Get the total student count for the year
  int? yearStudentList(Year? year) {
    if (year != null) {
      int runningCount = 0;
      for (var course in year.courses) {
        runningCount += course.students.toList().length;
      }
      return runningCount;
    }
    return null;
  }

  // Function to display the calendar popup
  Future<void> _selectDate(BuildContext context, int calendarNumber) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // You can adjust this as per your needs
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (calendarNumber == 1) {
          selectedStartDate = pickedDate;
        } else if (calendarNumber == 2) {
          // Ensure second date is not before the first date
          if (selectedEndDate != null &&
              pickedDate.isBefore(selectedStartDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('The end date cannot be before the start date.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            selectedEndDate = pickedDate;
          }
        }
      });
    }
  }

  //Calculate grade statistics
  void calculateStatistic(List<Course>? selectedCourses, Year selectedYear) {
    List<double> gradeList = [];
    List<Student> studentList = [];

    // If a course is selected
    if (selectedCourses != null) {
      for (var course in selectedCourses) {
        for (var student in course.students) {
          studentList.add(student);
          if (student.studentNumberGrade != null) {
            gradeList.add(student.studentNumberGrade!);
          }
        }
      }
    } else {
      // If no course selected, calculate for the whole year
      for (var course in selectedYear.courses) {
        for (var student in course.students) {
          studentList.add(student);
          if (student.studentNumberGrade != null) {
            gradeList.add(student.studentNumberGrade!);
          }
        }
      }
    }

    // Handle empty grade list case
    if (gradeList.isEmpty) {
      setState(() {
        selectedItemStatistics = {
          'max': {'student': 'N/A', 'period': 'N/A', 'grade': 'N/A'},
          'min': {'student': 'N/A', 'period': 'N/A', 'grade': 'N/A'},
          'avg': 'No grades available',
          'sd': 'No grades available',
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
      'course' : highestStudent.courses.toList()[0].courseName,
      'period': highestStudent.courses.toList()[0].coursePeriod,
      'grade': highestStudent.studentNumberGrade
    };

    // Min Grade
    Student lowestStudent = studentList.firstWhere(
        (student) => student.studentNumberGrade == statisticGradeList.min);
    statistics['min'] = {
      'student': lowestStudent.studentName,
      'course' : highestStudent.courses.toList()[0].courseName,
      'period': lowestStudent.courses.toList()[0].coursePeriod,
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

  //Open the color picker
  Future<void> _openColorPicker(Year? year, SettingsCubit settingsCubit) async {
    int? colorPickerResult = await showDialog<int>(
      context: context,
      builder: (context) => ColorPickerDialog(
        availableColors: AvailableColors.colors,
        yearColorId: year?.yearColorId ?? addYearColor ?? settingsCubit.state.appThemeInt,
      ),
    );
    if (colorPickerResult != null) {
      if (year != null) {
        setState(() {
          if (year.yearColorId != colorPickerResult) {
            colorChanged = true;
            selectedYear!.yearColorId = colorPickerResult;
          }
        });
      } else if (addYear == true) {
        setState(() {
          addYearColor = colorPickerResult;
        });
      } else {

        settingsCubit.updateAppColor(colorPickerResult);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final yearCubit = context.read<YearCubit>();

    nameController.text = settingsCubit.state.teacherName;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        themeCubit.selectTheme(settingsState.appThemeInt);

        return BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, appTheme) {

            return Scaffold(
              key: _scaffoldKey,
              endDrawer: SettingsDrawer(
                  screenTheme: appTheme,
                  themeCubit: themeCubit,
                  settingsCubit: settingsCubit,
                  nameController: nameController,
                  onTap: () => _openColorPicker(null, settingsCubit),),
                  
              backgroundColor: appTheme.colorScheme.surface,
              body: Padding(
                padding: EdgeInsets.all(elementPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left half - Teacher greeting and year selection
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(right: elementPadding / 2),
                        child: Column(
                          children: [
                            // Welcome message
                            Flexible(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome back ${settingsState.teacherName}!",
                                      style: TextStyle(
                                        fontSize: 45,
                                        color: appTheme
                                            .colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      "Please select a year below..",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: appTheme
                                            .colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Decade selector and year grid
                            Expanded(
                              flex: 12,
                              child: BlocBuilder<YearCubit, YearState>(
                                builder: (context, yearState) {
                                  if (yearState is YearsLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (yearState is YearsLoaded) {
                                    groupedYears = groupYearsByDecade(
                                        yearState.schoolYears);
                                    final decades = groupedYears.keys.toList();
                                    if (decades.isNotEmpty) {
                                      _initializeTabController(
                                          yearState.schoolYears);
            
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: appTheme
                                                .colorScheme.surface,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Column(
                                          children: [
                                            // Decade selector
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                                color: appTheme
                                                    .colorScheme.primary,
                                              ),
                                              child: TabBar(
                                                labelStyle:
                                                    TextStyle(fontSize: 25),
                                                indicator: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(7),
                                                          topRight:
                                                              Radius.circular(
                                                                  7)),
                                                  color: appTheme
                                                      .colorScheme.tertiary,
                                                ),
                                                indicatorPadding:
                                                    EdgeInsets.all(2),
                                                dividerColor: appTheme
                                                    .colorScheme.tertiary,
                                                dividerHeight: 5,
                                                indicatorColor:
                                                    appTheme
                                                        .colorScheme.surface,
                                                labelColor: appTheme
                                                    .colorScheme.onTertiary,
                                                controller: _tabController,
                                                tabs: decades
                                                    .map((decade) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child:
                                                              Tab(text: decade),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                            // Year grid
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15)),
                                                  color: appTheme
                                                      .colorScheme.primary,
                                                ),
                                                child: TabBarView(
                                                  controller: _tabController,
                                                  children:
                                                      decades.map((decade) {
                                                    return LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              GridView.builder(
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              mainAxisExtent:
                                                                  (constraints.maxHeight /
                                                                          5 -
                                                                      4),
                                                            ),
                                                            itemCount: groupedYears[
                                                                        decade]
                                                                    ?.length ??
                                                                0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final year =
                                                                  groupedYears[
                                                                          decade]![
                                                                      index];
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      NeumorphicTextButton(
                                                                    buttonText: year
                                                                        .year
                                                                        .toString(),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        selectedYear =
                                                                            year;
                                                                        yearTextController.text =
                                                                            year.year;
                                                                        selectedStartDate =
                                                                            year.startDate;
                                                                        selectedEndDate =
                                                                            year.endDate;
                                                                        locationController.text =
                                                                            year.location;
                                                                        schoolNameController.text =
                                                                            year.schoolName;
                                                                        selectedYearTheme =
                                                                            getCurrentTheme(year.yearColorId, themeCubit, settingsState);
                                                                        calculateStatistic(
                                                                            null,
                                                                            selectedYear!);
                                                                        addYear =
                                                                            false;
                                                                        textChanged =
                                                                            false;
                                                                      });
                                                                    },
                                                                    buttonColor:
                                                                        getCurrentTheme(
                                                                      year.yearColorId,
                                                                      themeCubit,
                                                                      settingsState
                                                                    ).primaryColor,
                                                                    buttonTextColor:
                                                                        getCurrentTheme(
                                                                      year.yearColorId,
                                                                      themeCubit,
                                                                      settingsState
                                                                    ).primaryColorDark,
                                                                    buttonTextSize:
                                                                        40,
                                                                    screenTheme:
                                                                        appTheme,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No decades found."));
                                    }
                                  } else {
                                    return Center(
                                        child: Text(
                                            "Error loading years! $yearState"));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            
                    // Right half - Add year button, settings button, and year preview
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: elementPadding / 2),
                        child: Column(children: [
                          // Settings and add year buttons
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: elementPadding / 2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Add year button (4x the width of the Settings button)
                                          Flexible(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: NeumorphicTextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    addYear = true;
                                                    selectedYear = null;
                                                    textChanged = false;
                                                    selectedYearTheme = getCurrentTheme(settingsState.appThemeInt, themeCubit, settingsState);
                                                    yearTextController.text =
                                                        "";
                                                    locationController.text =
                                                        "";
                                                    schoolNameController.text =
                                                        "";
                                                    selectedStartDate = null;
                                                    selectedEndDate = null;
                                                  });
                                                },
                                                buttonText: "Add year...",
                                                screenTheme: appTheme,
                                              ),
                                            ),
                                          ),
            
                                          // Settings button (perfect square)
                                          Flexible(
                                            flex: 2,
                                            child: AspectRatio(
                                              aspectRatio:
                                                  1, // Ensures the button is a perfect square
                                              child: NeumorphicIconButton(
                                                onPressed: () {
                                                  _scaffoldKey.currentState!
                                                      .openEndDrawer();
            
                                                  setState(() {
                                                    selectedYearTheme = getCurrentTheme(selectedYear != null ? selectedYear!.yearColorId : addYearColor ?? settingsState.appThemeInt, themeCubit, settingsState);
                                                  });
                                                },
                                                buttonIcon: Icons.settings,
                                                currentTheme: appTheme,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          if (selectedYear != null || addYear == true)
                            // Year preview box
                            Expanded(
                              flex: 22,
                              child: Padding(
                                padding: EdgeInsets.only(top: elementPadding / 2),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: selectedYearTheme?.colorScheme.primary ?? appTheme.colorScheme.primary,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Year text field
                                      Flexible(
                                        flex: 2,
                                        child: FractionallySizedBox(
                                          alignment: Alignment.center,
                                          widthFactor: 0.25,
                                          child: NeumorphicTextField(
                                            onChanged: (text) {
                                              setState(() {
                                                textChanged = true;
                                              });
                                            },
                                            hintText: yearTextController
                                                    .text.isNotEmpty
                                                ? yearTextController.text
                                                : "Year",
                                            textController: yearTextController,
                                            screenTheme: selectedYearTheme ??
                                                appTheme,
                                            fontSize: 65,
                                            cursorHeight: 60,
                                          ),
                                        ),
                                      ),
            
                                      //Start and End Date Boxes
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // Center horizontally
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Center vertically for all children
                                          children: [
                                            // Start Date Container
                                            Flexible(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _selectDate(context, 1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: selectedYearTheme
                                                              ?.colorScheme
                                                              .tertiary ??
                                                          appTheme
                                                              .colorScheme
                                                              .tertiary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        selectedStartDate ==
                                                                null
                                                            ? "Select Start Date"
                                                            : DateFormat('MMMM dd, yyyy').format(selectedStartDate!),
                                                        style: TextStyle(
                                                          color: selectedYearTheme
                                                                  ?.colorScheme
                                                                  .onTertiary ??
                                                              appTheme
                                                                  .colorScheme
                                                                  .onTertiary,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
            
                                            // End Date Container
                                            Flexible(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _selectDate(context, 2),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: selectedYearTheme
                                                              ?.colorScheme
                                                              .tertiary ??
                                                          appTheme
                                                              .colorScheme
                                                              .tertiary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        selectedEndDate == null
                                                            ? "Select End Date"
                                                            : DateFormat(
                                                                    'MMMM dd, yyyy')
                                                                .format(
                                                                    selectedEndDate!),
                                                        style: TextStyle(
                                                          color: selectedYearTheme
                                                                  ?.colorScheme
                                                                  .onTertiary ??
                                                              appTheme
                                                                  .colorScheme
                                                                  .onTertiary,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
            
                                      // Text field for school and city
                                      Flexible(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //School Name Text Field
                                            Flexible(
                                              flex: 10,
                                              child: NeumorphicTextField(
                                                cursorHeight: 50,
                                                hintText: "School Name",
                                                textController:
                                                    schoolNameController,
                                                screenTheme:
                                                    selectedYearTheme ??
                                                        appTheme,
                                                fontSize: 25,
                                                onChanged: (text) {
                                                  setState(() {
                                                    textChanged = true;
                                                  });
                                                },
                                              ),
                                            ),
                                            //Location
                                            Flexible(
                                              fit: FlexFit.tight,
                                              flex: 5,
                                              child: NeumorphicTextField(
                                                  cursorHeight: 50,
                                                  hintText: "City, State",
                                                  textController:
                                                      locationController,
                                                  screenTheme:
                                                      selectedYearTheme ??
                                                          appTheme,
                                                  fontSize: 25,
                                                  onChanged: (text) {
                                                    setState(() {
                                                      textChanged = true;
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
            
                                      // Class toggle and add button
                                      Flexible(
                                        flex: 1,
                                        child: BlocProvider(
                                          create: (context) =>
                                              CourseCubit(TeacherRepo()),
                                          child: BlocBuilder<CourseCubit,
                                              CourseState>(
                                            builder: (context, courseState) {
                                              if (courseState is CourseLoaded) {
                                                return YearPageClassToggle(
                                                  selectedYear: selectedYear,
                                                  courses: courseState.courses,
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return BlocProvider
                                                            .value(
                                                          value: context.read<
                                                              CourseCubit>(),
                                                          child: CourseDialog(
                                                              yearId:
                                                                  selectedYear!
                                                                      .id,
                                                              isEditing: false),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  screenTheme:
                                                      selectedYearTheme ??
                                                          appTheme,
                                                  onOptionChanged:
                                                      (listOfCourses) {
                                                    setState(() {
                                                      selectedCourseList =
                                                          listOfCourses;
                                                      calculateStatistic(
                                                          selectedCourseList,
                                                          selectedYear!);
                                                    });
                                                  },
                                                );
                                              } else if (courseState
                                                  is CourseInitial) {
                                                return YearPageClassToggle(
                                                    selectedYear: selectedYear,
                                                    courses: selectedYear
                                                            ?.courses
                                                            .toList() ??
                                                        dummyCourses,
                                                    onPressed: () {
                                                      if (addYear == true) {
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder:
                                                              (dialogContext) {
                                                            return BlocProvider
                                                                .value(
                                                              value: context.read<
                                                                  CourseCubit>(),
                                                              child: CourseDialog(
                                                                  yearId:
                                                                      selectedYear!
                                                                          .id,
                                                                  isEditing:
                                                                      false),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    screenTheme:
                                                        selectedYearTheme ??
                                                            appTheme,
                                                    onOptionChanged:
                                                        (listOfCourses) {
                                                      if (addYear == true) {
                                                        null;
                                                      } else {
                                                        setState(() {
                                                          selectedCourseList =
                                                              listOfCourses;
                                                          calculateStatistic(
                                                              selectedCourseList,
                                                              selectedYear!);
                                                        });
                                                      }
                                                    });
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
            
                                      // Statistics preview
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Left column: student count and grade breakdown
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        flex: 5,
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: selectedYearTheme
                                                                            ?.colorScheme
                                                                            .secondary ??
                                                                        appTheme
                                                                            .colorScheme
                                                                            .secondary),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Total Students: ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25,
                                                                          color:
                                                                              selectedYearTheme?.colorScheme.onSecondary ?? appTheme.colorScheme.onSecondary),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                      selectedCourseList
                                                                              ?.fold(0, (sum, course) => sum + course.students.toList().length)
                                                                              .toString() ??
                                                                          yearStudentList(selectedYear)?.toString() ??
                                                                          "42",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              selectedYearTheme?.colorScheme.onSecondary ?? appTheme.colorScheme.onSecondary),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: selectedYearTheme
                                                                            ?.colorScheme
                                                                            .secondary ??
                                                                        appTheme
                                                                            .colorScheme
                                                                            .secondary),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Total ${selectedCourseList?[0].courseName ?? selectedYear?.year ?? "Example"} Periods: ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25,
                                                                          color:
                                                                              selectedYearTheme?.colorScheme.onSecondary ?? appTheme.colorScheme.onSecondary),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(selectedCourseList?.length.toString() ?? selectedYear?.courses.toList().length.toString() ?? "12",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              selectedYearTheme?.colorScheme.onSecondary ?? appTheme.colorScheme.onSecondary),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                      Flexible(
                                                        flex: 8,
                                                        child: GradeBreakdown(
                                                          selectedYear:
                                                              selectedYear,
                                                          selectedCourseList:
                                                              selectedCourseList,
                                                          screenTheme:
                                                              selectedYearTheme ??
                                                                  appTheme,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
            
                                              VerticalDivider(
                                                thickness: 2,
                                                color: selectedYearTheme
                                                        ?.colorScheme
                                                        .onPrimary ??
                                                    appTheme
                                                        .colorScheme.onPrimary,
                                                width: 20,
                                              ),
            
                                              // Right column: grade statistics
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          color: selectedYearTheme
                                                                  ?.colorScheme
                                                                  .secondary ??
                                                              appTheme
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: selectedYearTheme
                                                                        ?.colorScheme
                                                                        .primary ??
                                                                    appTheme
                                                                        .colorScheme
                                                                        .primary,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    addYear
                                                                        ? 'Bob Bobbington'
                                                                        : "${selectedItemStatistics['max']['student']}",
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme
                                                                                .colorScheme.onPrimary,
                                                                        fontSize:
                                                                            40,
                                                                        overflow:
                                                                            TextOverflow.fade),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      selectedCourseList != null ? addYear ? '1A | 100' : "${selectedItemStatistics['max']['period']} | ${selectedItemStatistics['max']['grade']}" : addYear ? '1A | 100' : "${selectedItemStatistics['max']['course']} | ${selectedItemStatistics['max']['period']} | ${selectedItemStatistics['max']['grade']}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme.colorScheme.onPrimary,
                                                                        fontSize:
                                                                            30,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "Highest Grade",
                                                                      style:
                                                                          TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme.colorScheme.onPrimary,
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: selectedYearTheme
                                                                        ?.colorScheme
                                                                        .primary ??
                                                                    appTheme
                                                                        .colorScheme
                                                                        .primary,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    addYear
                                                                        ? 'Bob Bobbington'
                                                                        : "${selectedItemStatistics['min']['student']}",
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme
                                                                                .colorScheme.onPrimary,
                                                                        fontSize:
                                                                            40,
                                                                        overflow:
                                                                            TextOverflow.fade),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                        selectedCourseList != null ? addYear ? '1A | 100' : "${selectedItemStatistics['min']['period']} | ${selectedItemStatistics['min']['grade']}" : addYear ? '1A | 100' : "${selectedItemStatistics['min']['course']} | ${selectedItemStatistics['min']['period']} | ${selectedItemStatistics['min']['grade']}",                                                                      style:
                                                                          TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme.colorScheme.onPrimary,
                                                                        fontSize:
                                                                            30,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "Lowest Grade",
                                                                      style:
                                                                          TextStyle(
                                                                        color: selectedYearTheme?.colorScheme.onPrimary ??
                                                                            appTheme.colorScheme.onPrimary,
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
            
                                      // Action buttons for editing and deleting
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                // Delete button
                                                SizedBox(
                                                  width: 150,
                                                  child: NeumorphicTextButton(
                                                    buttonText: "Delete",
                                                    onPressed: () {
                                                      if (addYear == true) {
                                                        addYear == false;
                                                      } else {
                                                        yearCubit.deleteYear(
                                                            selectedYear!.id);
                                                        setState(() {
                                                          selectedYear = null;
                                                          selectedYearTheme =
                                                              null;
                                                          selectedCourseList =
                                                              null;
                                                          selectedStartDate =
                                                              null;
                                                          selectedEndDate =
                                                              null;
                                                          yearTextController
                                                              .clear();
                                                          locationController
                                                              .clear();
                                                          schoolNameController
                                                              .clear();
                                                        });
                                                      }
                                                    },
                                                    screenTheme:
                                                        selectedYearTheme ??
                                                            appTheme,
                                                    buttonColor:
                                                        selectedYearTheme
                                                                ?.colorScheme
                                                                .error ??
                                                            appTheme
                                                                .colorScheme
                                                                .error,
                                                  ),
                                                ),
            
                                                SizedBox(width: 15),
            
                                                // Color button
                                                SizedBox(
                                                    width: 150,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await _openColorPicker(selectedYear, settingsCubit);
                                                        setState(() {
                                                          selectedYearTheme = getCurrentTheme(selectedYear?.yearColorId ?? addYearColor!, themeCubit, settingsState);
                                                          selectedYearColor = selectedYear?.yearColorId;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: selectedYearTheme
                                                                  ?.primaryColor ??
                                                              appTheme
                                                                  .primaryColor,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          'Color',
                                                          style: TextStyle(
                                                              color: selectedYearTheme
                                                                      ?.primaryColorDark ??
                                                                  appTheme
                                                                      .primaryColorDark,
                                                              fontSize: 17),
                                                        )),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            BlocBuilder<YearCubit, YearState>(
                                              builder: (context, yearState) {
                                                if (yearState is YearsLoaded) {
                                                  if (addYear == true) {
                                                    return SizedBox(
                                                      width: 300,
                                                      child:
                                                          NeumorphicTextButton(
                                                        buttonText: "Add Year",
                                                        onPressed: () {
                                                          // Check if the user is adding a new year
                                                          if (yearState
                                                              .schoolYears
                                                              .any((year) =>
                                                                  year.year !=
                                                                  yearTextController
                                                                      .text)) {
                                                            // Add the year if it doesn't already exist
                                                            context
                                                                .read<
                                                                    YearCubit>()
                                                                .addYear(
                                                                  yearTextController
                                                                      .text,
                                                                  addYearColor ?? settingsState.appThemeInt,
                                                                  selectedStartDate!,
                                                                  selectedEndDate!,
                                                                  schoolNameController
                                                                      .text,
                                                                  locationController
                                                                      .text,
                                                                );
                                                          } else {
                                                            // Show an error SnackBar if the year already exists
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "This year already exists",
                                                                  style: TextStyle(
                                                                      color: selectedYearTheme
                                                                              ?.colorScheme
                                                                              .onError ??
                                                                          appTheme
                                                                              .colorScheme
                                                                              .onError),
                                                                ),
                                                                backgroundColor: selectedYearTheme
                                                                        ?.colorScheme
                                                                        .error ??
                                                                    appTheme
                                                                        .colorScheme
                                                                        .error,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              ),
                                                            );
                                                          }
                                                          setState(() {
                                                            addYear = false;
                                                          });
                                                          schoolNameController
                                                                  .text ==
                                                              '';
                                                          locationController
                                                                  .text ==
                                                              '';
                                                        },
                                                        screenTheme:
                                                            selectedYearTheme ??
                                                                appTheme,
                                                      ),
                                                    );
                                                  } else {
                                                    Year schoolYearFromState =
                                                        yearState.schoolYears
                                                            .firstWhere(
                                                                (year) =>
                                                                    year.id ==
                                                                    selectedYear
                                                                        ?.id);
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 25,
                                                        ),
                                                        // Save changes to year
                                                        // Get selected school year from year state
            
                                                        if (textChanged ==
                                                                true ||
                                                            colorChanged ==
                                                                true ||
                                                            selectedStartDate !=
                                                                schoolYearFromState
                                                                    .startDate ||
                                                            selectedEndDate !=
                                                                schoolYearFromState
                                                                    .endDate)
                                                          SizedBox(
                                                            width: 125,
                                                            child:
                                                                NeumorphicTextButton(
                                                              buttonText:
                                                                  "Save Changes",
                                                              onPressed: () {
                                                                // Check if the user is adding a new year
                                                                bool
                                                                    yearExists = yearState.schoolYears.any((year) =>year.year ==
                                                                      yearTextController
                                                                          .text,
                                                                );
            
                                                                if (!yearExists || selectedYear!.year == yearTextController.text) {
                                                                  // Edit the year if it doesn't already exist
                                                                  context
                                                                      .read<YearCubit>().editYear(
                                                                        selectedYear!.id,
                                                                        yearTextController.text,
                                                                        selectedYearColor,
                                                                        selectedStartDate,
                                                                        selectedEndDate,
                                                                        schoolNameController.text,
                                                                        locationController.text,
                                                                      );
                                                                } else {
                                                                  // Show an error SnackBar if the year already exists
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        "This year already exists",
                                                                        style: TextStyle(
                                                                            color:
                                                                                selectedYearTheme?.colorScheme.onError ?? appTheme.colorScheme.onError),
                                                                      ),
                                                                      backgroundColor: selectedYearTheme
                                                                              ?.colorScheme
                                                                              .error ??
                                                                          appTheme
                                                                              .colorScheme
                                                                              .error,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    ),
                                                                  );
                                                                }
                                                                textChanged =
                                                                    false;
                                                                colorChanged =
                                                                    false;
                                                              },
                                                              screenTheme:
                                                                  selectedYearTheme ??
                                                                      appTheme,
                                                            ),
                                                          ),
                                                        SizedBox(
                                                          width: 25,
                                                        ),
                                                        // Navigate button
                                                        SizedBox(
                                                          width: 300,
                                                          child: NeumorphicTextButton(
                                                            buttonText: "Navigate",
                                                            onPressed: () {
                                                              Navigator.of(context).pushReplacement(
                                                                MaterialPageRoute(
                                                                  builder: (context) => MultiBlocProvider(
                                                                    providers: [
                                                                      BlocProvider.value(value: context.read<ThemeCubit>()),
                                                                      BlocProvider.value(value: context.read<SettingsCubit>()),
                                                                      BlocProvider(create: (context) => CourseCubit(TeacherRepo())),
                                                                    ],
                                                                    child: CoursePage(currentYear: selectedYear!,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            screenTheme:
                                                                selectedYearTheme ??
                                                                    appTheme,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                }
                                                return SizedBox(width: 25);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
            
                          if (selectedYear == null && addYear == false)
                            Expanded(
                              flex: 22,
                              child: SizedBox(),
                            )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
