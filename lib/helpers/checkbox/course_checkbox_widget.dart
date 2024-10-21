import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/helpers/checkbox/checkbox_cubit.dart';
import '../../storage/course/course.dart';

class CourseCheckboxList extends StatefulWidget {
  final List<Course> list;
  final List<Course> selectedCourses; 

  const CourseCheckboxList({
    super.key,
    required this.list,
    required this.selectedCourses,
  });

  @override
  CourseCheckboxListState createState() => CourseCheckboxListState();
}

class CourseCheckboxListState extends State<CourseCheckboxList> {
  @override
  void initState() {
    super.initState();
    // Initialize the CheckboxCubit with the selected courses
    context.read<CheckboxCubit<Course>>().initialize(widget.selectedCourses);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.list.isEmpty) {
      return Center(child: Text("No courses available"));
    }

    return SizedBox(
      height: 200, // Set a fixed height
      child: BlocBuilder<CheckboxCubit<Course>, List<Course>>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              final course = widget.list[index];
              final bool isSelected = (state.any((stateCourse) => course.courseId == stateCourse.courseId));
              return CheckboxListTile(
                title: Text("${course.coursePeriod} | ${course.courseName}"),
                value: isSelected,
                onChanged: (bool? value) {
                  if (value != null) {
                    context
                        .read<CheckboxCubit<Course>>()
                        .toggleSelection(course);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
