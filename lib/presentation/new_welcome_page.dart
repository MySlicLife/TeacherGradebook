import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teacher_gradebook/modules/dialog/course_dialog.dart';
import 'package:teacher_gradebook/presentation/course_page.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/icon_button.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/text_button.dart';
import 'package:teacher_gradebook/presentation/widgets/radio/year_page_class_radio.dart';
import 'package:teacher_gradebook/presentation/widgets/text_field/text_field.dart';
import 'package:teacher_gradebook/storage/assignment/assignment_cubit.dart';
import 'package:teacher_gradebook/storage/course/course_cubit.dart';
import 'package:teacher_gradebook/storage/grade/grade_cubit.dart';
import 'package:teacher_gradebook/storage/student/student.dart';
import 'package:teacher_gradebook/storage/student/student_cubit.dart';
import 'package:teacher_gradebook/storage/teacher_repo.dart';
import 'package:statistics/statistics.dart';

import '../modules/dialog/color_picker_dialog.dart';
import '../storage/course/course.dart';
import '../storage/school_year/year.dart';
import '../storage/school_year/year_cubit.dart';
import 'theme/colors_copy.dart';
import 'theme/theme_cubit.dart';
import 'widgets/misc/grade_breakdown.dart';

class YearLandingPage extends StatefulWidget {
  final int mainAppThemeId;
  final String teacherName;

  const YearLandingPage({
    super.key,
    required this.teacherName,
    required this.mainAppThemeId,
  });

  @override
  State<YearLandingPage> createState() => _YearLandingPageState();
}

class _YearLandingPageState extends State<YearLandingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<Year>> groupedYears = {};
  late Year? selectedYear;
  late ThemeData? selectedYearTheme;
  late Course? selectedCourse;
  late Map<String, dynamic> selectedItemStatistics = {};
  late int? selectedYearColor;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  bool addYear = false;
  bool colorChanged = false;
  bool textChanged = false;
  int? addYearColor;

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
    context.read<ThemeCubit>().selectTheme(widget.mainAppThemeId);
    context.read<ThemeCubit>().isDarkMode; // Check if the app is in dark mode
    context
        .read<YearCubit>()
        .loadYears(); // Load all the years from the year cubit
    selectedYear = null;
    selectedYearTheme = null;
    selectedCourse = null;
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
  ThemeData getCurrentTheme(int yearColorId, ThemeCubit themeCubit) {
    var theme = themeCubit.colorThemes.firstWhere(
      (theme) => theme.colorThemeId == yearColorId,
    );
    return themeCubit.isDarkMode ? theme.darkMode : theme.lightMode;
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final themeCubit = context.read<ThemeCubit>();
    final yearCubit = context.read<YearCubit>();
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (themeContext, welcomeThemeState) {
        return Scaffold(
          backgroundColor: welcomeThemeState.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left half - Teacher greeting and year selection
                Expanded(
                  child: SizedBox(
                    width: screenWidth / 2,
                    child: Column(
                      children: [
                        // Welcome message
                        SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome back ${widget.teacherName}!",
                                style: TextStyle(
                                  fontSize: 45,
                                  color: welcomeThemeState.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                "Please select a year below..",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: welcomeThemeState.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Decade selector and year grid
                        BlocBuilder<YearCubit, YearState>(
                          builder: (context, yearState) {
                            if (yearState is YearsLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (yearState is YearsLoaded) {
                              groupedYears =
                                  groupYearsByDecade(yearState.schoolYears);
                              final decades = groupedYears.keys.toList();
                              if (decades.isNotEmpty) {
                                _initializeTabController(yearState.schoolYears);

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: welcomeThemeState.colorScheme.surface,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Column(
                                        children: [
                                          // Decade selector
                                          TabBar(
                                            indicator: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(7),
                                                  topRight: Radius.circular(7)),
                                              color: welcomeThemeState.colorScheme.primary,
                                            ),
                                            indicatorPadding: EdgeInsets.all(0),
                                            dividerColor: welcomeThemeState.colorScheme.primary,
                                            dividerHeight: 5,
                                            indicatorColor: welcomeThemeState.colorScheme.surface,
                                            labelColor: welcomeThemeState.colorScheme.onSurface,
                                            controller: _tabController,
                                            tabs: decades
                                                .map((decade) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Tab(text: decade),
                                                    ))
                                                .toList(),
                                          ),
                                          // Year grid
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: decades.map((decade) {
                                                return GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisExtent:
                                                        75, // Height of each grid item
                                                  ),
                                                  itemCount: groupedYears[decade]?.length ?? 0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final year = groupedYears[decade]![index];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          NeumorphicTextButton(
                                                        buttonText: year.year
                                                            .toString(),
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedYear = year;
                                                            yearTextController.text = year.year;
                                                            selectedStartDate = year.startDate;
                                                            selectedEndDate = year.endDate;
                                                            locationController.text = year.location;
                                                            schoolNameController.text = year.schoolName;
                                                            selectedYearTheme = getCurrentTheme(year.yearColorId, themeCubit,);
                                                            calculateStatistic(null, selectedYear!);
                                                            addYear = false;
                                                            textChanged = false;
                                                          });
                                                        },
                                                        buttonTheme:getCurrentTheme(year.yearColorId,themeCubit,),
                                                        screenTheme:
                                                            welcomeThemeState,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(child: Text("No decades found."));
                              }
                            } else {
                              return Center(
                                  child:
                                      Text("Error loading years! $yearState"));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Right half - Add year button, settings button, and year preview
                SizedBox(
                  width: screenWidth / 2,
                  child: Column(children: [
                    // Settings and add year buttons
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Add year button
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: NeumorphicTextButton(
                                      onPressed: () {
                                        setState(() {
                                          addYear = true;
                                          selectedYear = null;
                                          textChanged = false;
                                          selectedYearTheme = getCurrentTheme(widget.mainAppThemeId, themeCubit);
                                          yearTextController.text = "";
                                          locationController.text = "";
                                          schoolNameController.text = "";
                                          selectedStartDate = null;
                                          selectedEndDate = null;
                                        });
                                      },
                                      buttonText: "Add year...",
                                      screenTheme: welcomeThemeState,
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  // Settings button
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: NeumorphicIconButton(
                                      onPressed: () {
                                        themeCubit.toggleTheme();
                                        setState(() {
                                            selectedYearTheme = getCurrentTheme(selectedYear != null ? selectedYear!.yearColorId : widget.mainAppThemeId ,themeCubit,);
                                        });
                                      },
                                      buttonIcon: Icons.settings,
                                      currentTheme: welcomeThemeState,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Preview box window (add here)
                          ],
                        ),
                      ),
                    ),

                    if (selectedYear != null || addYear == true)
                      // Year preview box
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedYearTheme?.colorScheme.primary ?? welcomeThemeState.colorScheme.primary,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Year text field
                                SizedBox(
                                  height: 125,
                                  width: 250,
                                  child: NeumorphicTextField(
                                    onChanged: (text) {
                                      setState(() {
                                        textChanged = true;
                                      });
                                    },
                                    hintText: yearTextController.text.isNotEmpty ? yearTextController.text : "Year",
                                    textController: yearTextController,
                                    screenTheme: selectedYearTheme ?? welcomeThemeState,
                                    fontSize: 80,
                                    cursorHeight: 75,
                                  ),
                                ),

                                // Text field for start date and end date
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //Start Date
                                      GestureDetector(
                                        onTap: () => _selectDate(context, 1),
                                        child: Container(
                                          height: 50,
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: selectedYearTheme?.colorScheme.tertiary ?? welcomeThemeState.colorScheme.tertiary,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              selectedStartDate == null
                                                  ? "Tap to select a date"
                                                  : DateFormat('MMMM dd, yyyy')
                                                      .format(
                                                          selectedStartDate!),
                                              style: TextStyle(
                                                  color: selectedYearTheme?.colorScheme.onTertiary ?? welcomeThemeState.colorScheme.onTertiary,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Dash
                                      Container(
                                        width: 60, // Set a fixed width for the large dash
                                        alignment: Alignment.center,
                                        child: Text('-',
                                          style: TextStyle(
                                            fontSize:50, // Increase font size for the large dash
                                            color: selectedYearTheme?.colorScheme.onTertiary ?? welcomeThemeState.colorScheme.onTertiary,
                                          ),
                                        ),
                                      ),

                                      //End Date
                                      GestureDetector(
                                        onTap: () => _selectDate(context, 2),
                                        child: Container(
                                          height: 50,
                                          width: 200,
                                          decoration: BoxDecoration(
                                              color: selectedYearTheme?.colorScheme.tertiary ?? welcomeThemeState.colorScheme.tertiary,
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              selectedEndDate == null ? "Tap to select a date" : DateFormat('MMMM dd, yyyy').format(selectedEndDate!),
                                              style: TextStyle(
                                                  color: selectedYearTheme?.colorScheme.onTertiary ?? welcomeThemeState.colorScheme.onTertiary,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                // Text field for school and city
                                SizedBox(
                                  height: 75,
                                  child: Row(
                                    children: [
                                      //School Name Text Field
                                      SizedBox(
                                        width: 500,
                                        child: NeumorphicTextField(
                                            cursorHeight: 50,
                                            hintText: "School Name",
                                            textController: schoolNameController,
                                            screenTheme: selectedYearTheme ?? welcomeThemeState,
                                            fontSize: 25),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      //Bar
                                      Center(
                                        child: Text(
                                          "|",
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: selectedYearTheme?.colorScheme.onTertiary ?? welcomeThemeState.colorScheme.onTertiary),
                                        ),
                                      ),
                                      //Location
                                      Expanded(
                                          child: NeumorphicTextField(
                                              cursorHeight: 50,
                                              hintText: "Location",
                                              textController: locationController,
                                              screenTheme: selectedYearTheme ?? welcomeThemeState,
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                // Class toggle and add button
                                SizedBox(
                                  child: BlocProvider(
                                    create: (context) =>
                                        CourseCubit(TeacherRepo()),
                                    child:
                                        BlocBuilder<CourseCubit, CourseState>(
                                      builder: (context, courseState) {
                                        if (courseState is CourseLoaded) {
                                          return YearPageClassToggle(
                                            selectedYear: selectedYear,
                                            courses: courseState.courses,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return BlocProvider.value(
                                                    value: context.read<CourseCubit>(),
                                                    child: CourseDialog(
                                                        yearId: selectedYear!.id,
                                                        isEditing: false),
                                                  );
                                                },
                                              );
                                            },
                                            screenTheme: selectedYearTheme ?? welcomeThemeState,
                                            onOptionChanged: (newSelectedCourse) {
                                              setState(() {
                                                selectedCourse = newSelectedCourse;
                                                calculateStatistic(selectedCourse,selectedYear!);
                                              });
                                            },
                                          );
                                        } else if (courseState
                                            is CourseInitial) {
                                          return YearPageClassToggle(
                                              selectedYear: selectedYear,
                                              courses: selectedYear?.courses.toList() ?? dummyCourses,
                                              onPressed: () {
                                                if (addYear == true) {
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (dialogContext) {
                                                      return BlocProvider.value(
                                                        value: context.read<CourseCubit>(),
                                                        child: CourseDialog(
                                                            yearId:selectedYear!.id,
                                                            isEditing: false),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              screenTheme: selectedYearTheme ?? welcomeThemeState,
                                              onOptionChanged: (newSelectedCourse) {
                                                if (addYear == true) {
                                                  null;
                                                } else {
                                                  setState(() {
                                                    selectedCourse = newSelectedCourse;
                                                    calculateStatistic(selectedCourse,selectedYear!);
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

                                SizedBox(height: 10),

                                // Statistics preview
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Left column: student count and grade breakdown
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: selectedYearTheme?.colorScheme.secondary ?? welcomeThemeState.colorScheme.secondary),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Total Students: ",
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight.bold,
                                                          color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      selectedCourse?.students.length.toString() ?? yearStudentList(selectedYear)?.toString() ?? "40",
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GradeBreakdown(
                                                widgetWidth: screenWidth / 6 ,
                                                selectedYear: selectedYear,
                                                currentCourse: selectedCourse,
                                                screenTheme: selectedYearTheme ?? welcomeThemeState,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      VerticalDivider(
                                        thickness: 2,
                                        color: selectedYearTheme?.colorScheme.onPrimary ?? welcomeThemeState.colorScheme.onPrimary,
                                        width: 20,
                                      ),

                                      // Right column: grade statistics
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: selectedYearTheme?.colorScheme.secondary ?? welcomeThemeState.colorScheme.secondary,
                                              ),
                                              height: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Highest Grade",
                                                    style: TextStyle(
                                                      color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                    addYear
                                                        ? 'Temporary | 100' : "${selectedItemStatistics['max']['student']} | ${selectedItemStatistics['max']['grade']}",
                                                    style: TextStyle(
                                                      color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(height: 25),
                                                  Text(
                                                    "Lowest Grade",
                                                    style: TextStyle(
                                                      color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                    addYear
                                                        ? 'Temporary | 50' : "${selectedItemStatistics['min']['student']} | ${selectedItemStatistics['min']['grade']}",
                                                    style: TextStyle(
                                                      color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary,
                                                      fontSize: 20,
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

                                // Action buttons for editing and deleting
                                SizedBox(
                                  height: 50,
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
                                                    selectedYearTheme = null;
                                                    selectedCourse = null;
                                                    yearTextController.clear();
                                                  });
                                                }
                                              },
                                              screenTheme: selectedYearTheme ??  welcomeThemeState,
                                              buttonColor: selectedYearTheme?.colorScheme.error ?? welcomeThemeState.colorScheme.error,
                                            ),
                                          ),

                                          SizedBox(width: 15),

                                          // Color button
                                          SizedBox(
                                              width: 150,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await _openColorPicker(
                                                      selectedYear);
                                                  setState(() {
                                                    selectedYearTheme = getCurrentTheme(
                                                      selectedYear?.yearColorId ?? addYearColor!, 
                                                      themeCubit);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedYearTheme?.primaryColor ?? welcomeThemeState.primaryColor,
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Color',
                                                    style: TextStyle(
                                                        color: selectedYearTheme?.colorScheme.onSecondary ?? welcomeThemeState.colorScheme.onSecondary,
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
                                                child: NeumorphicTextButton(
                                                  buttonText: "Add Year",
                                                  onPressed: () {
                                                    // Check if the user is adding a new year
                                                    bool yearExists = yearState.schoolYears.any((year) => year.year == yearTextController.text,);

                                                    if (!yearExists) {
                                                      // Add the year if it doesn't already exist
                                                      context.read<YearCubit>().addYear(
                                                            yearTextController.text,
                                                            addYearColor ?? 0,
                                                            selectedStartDate!,
                                                            selectedEndDate!,
                                                            schoolNameController.text,
                                                            locationController.text,
                                                          );
                                                    } else {
                                                      // Show an error SnackBar if the year already exists
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text("This year already exists", style: TextStyle(color: selectedYearTheme?.colorScheme.onError ?? welcomeThemeState.colorScheme.onError),),
                                                          backgroundColor: selectedYearTheme?.colorScheme.error ?? welcomeThemeState.colorScheme.error,
                                                          duration: Duration(seconds: 3),
                                                        ),
                                                      );
                                                    }

                                                    schoolNameController.text == '';
                                                    locationController.text == '';
                                                  },
                                                  screenTheme: selectedYearTheme ?? welcomeThemeState,
                                                ),
                                              );
                                            } else {
                                              return Row(
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  // Save changes to year
                                                  if (textChanged == true || colorChanged == true)
                                                    SizedBox(
                                                      width: 125,
                                                      child: NeumorphicTextButton(
                                                        buttonText: "Save Changes",
                                                        onPressed: () {
                                                          // Check if the user is adding a new year
                                                          bool yearExists = yearState.schoolYears.any((year) => year.year == yearTextController.text,
                                                          );

                                                          if (!yearExists) {
                                                            // Add the year if it doesn't already exist
                                                            context.read<YearCubit>().editYear(
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
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                          content: Text("This year already exists", style: TextStyle(color: selectedYearTheme?.colorScheme.onError ?? welcomeThemeState.colorScheme.onError),),
                                                          backgroundColor: selectedYearTheme?.colorScheme.error ?? welcomeThemeState.colorScheme.error,
                                                          duration: Duration(seconds: 3),
                                                        ),
                                                            );
                                                          }
                                                          schoolNameController.text == '';
                                                          locationController.text == '';
                                                        },
                                                        screenTheme: selectedYearTheme ?? welcomeThemeState,
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
                                                                BlocProvider(create: (context) => CourseCubit(TeacherRepo())),
                                                                BlocProvider(create: (context) => ThemeCubit()),
                                                                BlocProvider(create: (context) => AssignmentCubit(TeacherRepo())),
                                                                BlocProvider(create: (context) => StudentCubit(TeacherRepo())),
                                                                BlocProvider(create: (context) => GradeCubit(TeacherRepo())),
                                                              ],
                                                              child: CoursePage(
                                                                currentCourse:selectedCourse!,
                                                                currentYear:selectedYear!,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      screenTheme: selectedYearTheme ?? welcomeThemeState,
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
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void calculateStatistic(Course? selectedCourse, Year selectedYear) {
    List<double> gradeList = [];
    List<Student> studentList = [];

    // If a course is selected
    if (selectedCourse != null) {
      for (var student in selectedCourse.students) {
        studentList.add(student);
        if (student.studentNumberGrade != null) {
          gradeList.add(student.studentNumberGrade!);
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
          'max': {'student': 'N/A', 'grade': 'N/A'},
          'min': {'student': 'N/A', 'grade': 'N/A'},
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
    Student highestStudent = studentList.firstWhere((student) => student.studentNumberGrade == statisticGradeList.max);
    statistics['max'] = {
      'student': highestStudent.studentName,
      'grade': highestStudent.studentNumberGrade
    };

    // Min Grade
    Student lowestStudent = studentList.firstWhere((student) => student.studentNumberGrade == statisticGradeList.min);
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

  Future<void> _openColorPicker(Year? year) async {
    int? colorPickerResult = await showDialog<int>(
      context: context,
      builder: (context) => ColorPickerDialog(
        availableColors: AvailableColors.colors,
        yearColorId: year?.yearColorId ?? addYearColor ?? widget.mainAppThemeId,
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
      } else {
        setState(() {
          addYearColor = colorPickerResult;
        });
      }
    }
  }
}
