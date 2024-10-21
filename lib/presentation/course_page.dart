import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/widgets/custom_row/grade_grid.dart';
import '../storage/assignment/assignment_cubit.dart';
import '../storage/course/course.dart';
import '../storage/grade/grade_cubit.dart';
import '../storage/school_year/year.dart';
import '../storage/student/student_cubit.dart';
import '../storage/teacher_repo.dart';

class CoursePage extends StatefulWidget {
  final Year currentYear;
  final Course currentCourse;

  const CoursePage({
    super.key,
    required this.currentCourse,
    required this.currentYear,
  });

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<AssignmentCubit>()
        .loadAssignments(widget.currentCourse.courseId, widget.currentYear.id);
    context
        .read<StudentCubit>()
        .loadStudents(widget.currentYear.id, widget.currentCourse.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title Part
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  heroTag: "goBack",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              // Title
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${widget.currentCourse.coursePeriod} | ${widget.currentCourse.courseName} | ${widget.currentYear.year}",
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ],
          ),

          // Show Statistics
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.blue,
            child: Center(child: Text("Statistics")),
          ),

          // Grades grid
          MultiBlocProvider(providers: [
            BlocProvider.value(value: context.read<AssignmentCubit>()),
            BlocProvider.value(value: context.read<StudentCubit>()),
            BlocProvider(create: (context) => GradeCubit(TeacherRepo()))
          ], child: GradeGrid(currentCourse: widget.currentCourse, currentYear: widget.currentYear,)),
          

                // Floating Action Button to Add Student

              ],
            ),
          ); 
}
}