import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/modules/dialog/course_dialog.dart';
import 'package:teacher_gradebook/presentation/course_page.dart';
import 'package:teacher_gradebook/storage/assignment/assignment_cubit.dart';
import 'package:teacher_gradebook/storage/course/course_cubit.dart';
import 'package:teacher_gradebook/storage/school_year/year.dart';
import 'package:teacher_gradebook/storage/student/student_cubit.dart';
import 'package:teacher_gradebook/storage/teacher_repo.dart';

import '../storage/course/course.dart';
import 'theme/theme_cubit.dart';

class YearPage extends StatefulWidget {
  final Year year;
  final int yearThemeId;
  const YearPage({super.key, required this.year, required this.yearThemeId});

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().loadCourses(widget.year.id);
    context.read<ThemeCubit>().selectTheme(widget.yearThemeId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        return Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: FloatingActionButton(
                        heroTag: "goBack",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Column(
                      children: [
                        // Shows what year teacher is in
                        Center(
                            child: Text(widget.year.year,
                                style: TextStyle(fontSize: 40))),

                        // Select Class You want to modify text
                        Center(
                          child: Text(
                            "Select a Class Below",
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                // Show list tiles of courses
                Expanded(
                  child: BlocBuilder<CourseCubit, CourseState>(
                    builder: (context, state) {
                      if (state is CourseLoading) {
                        return CircularProgressIndicator();
                      } else if (state is CourseLoaded) {
                        if (state.courses.isEmpty) {
                          return Center(
                            child: Text("No Courses Found... Please Add Some!"),
                          );
                        } else {
                          return Row(
                            children: [
                              // A Block
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    // Get the filtered list of courses containing 'A' or 'a'
                                    List<Course> aCourses = state.year.courses
                                        .where((course) => course.coursePeriod
                                            .toUpperCase()
                                            .contains('A'))
                                        .toList();

                                    // Check if there are any A-day courses
                                    if (aCourses.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No A-day courses available',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      );
                                    }

                                    // If there are courses, build the ListView
                                    return ListView.builder(
                                      itemCount: aCourses.length,
                                      itemBuilder: (context, index) {
                                        var course = aCourses[index];

                                        return SizedBox(
                                          width: 200,
                                          child: ListTile(
                                            title: Center(
                                              child: Text(
                                                '${course.coursePeriod} | ${course.courseName}',
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            StudentCubit(
                                                                TeacherRepo()),
                                                      ),
                                                      BlocProvider(
                                                          create: (context) =>
                                                              AssignmentCubit(
                                                                  TeacherRepo())),
                                                    ],
                                                    child: CoursePage(
                                                      currentYear: state.year,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            onLongPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (dialogContext) =>
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CourseCubit>(),
                                                        child: CourseDialog(
                                                          yearId:
                                                              widget.year.id,
                                                          isEditing: true,
                                                          currentCourse: course,
                                                        ),
                                                      ));
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              // B Block
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    // Get the filtered list of courses containing 'B' or 'b'
                                    List<Course> bCourses = state.year.courses
                                        .where((course) => course.coursePeriod
                                            .toUpperCase()
                                            .contains('B'))
                                        .toList();

                                    // Check if there are any B-day courses
                                    if (bCourses.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No B-day courses available',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      );
                                    }

                                    // If there are courses, build the ListView
                                    return ListView.builder(
                                      itemCount: bCourses.length,
                                      itemBuilder: (context, index) {
                                        var course = bCourses[index];

                                        return SizedBox(
                                          width: 200,
                                          child: ListTile(
                                            title: Center(
                                              child: Text(
                                                '${course.coursePeriod} | ${course.courseName}',
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            StudentCubit(
                                                                TeacherRepo()),
                                                      ),
                                                      BlocProvider(
                                                          create: (context) =>
                                                              AssignmentCubit(
                                                                  TeacherRepo())),
                                                    ],
                                                    child: CoursePage(
                                                      currentYear: state.year,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            onLongPress: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (dialogContext) =>
                                                      BlocProvider.value(
                                                        value: context.read<
                                                            CourseCubit>(),
                                                        child: CourseDialog(
                                                          yearId:
                                                              widget.year.id,
                                                          isEditing: true,
                                                          currentCourse: course,
                                                        ),
                                                      ));
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      throw Exception(
                          "State is not what is expected, actual state $state");
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "addCourse",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                          value: context.read<CourseCubit>(),
                          child: CourseDialog(
                            yearId: widget.year.id,
                            isEditing: false,
                          ),
                        ));
              },
              child: Icon(Icons.add),
            ));
      },
    );
  }
}
