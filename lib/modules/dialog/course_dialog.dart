

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:teacher_gradebook/helpers/checkbox/period_checkbox.dart';

import '../../storage/course/course.dart';
import '../../storage/course/course_cubit.dart';

class CourseDialog extends StatefulWidget {
  final Id yearId;
  final bool isEditing;
  final Course? currentCourse;

  const CourseDialog({
    super.key,
    required this.yearId,
    required this.isEditing,
    this.currentCourse,
  });

  @override
  CourseDialogState createState() => CourseDialogState();
}

class CourseDialogState extends State<CourseDialog> {
  final _courseNameController = TextEditingController();
  String _coursePeriod = ''; // Store the selected course period

  void _saveButton(BuildContext context) {
    String courseName = _courseNameController.text;

    if (widget.isEditing && widget.currentCourse != null) {
      context.read<CourseCubit>().editCourse(widget.currentCourse!.courseId, widget.yearId, courseName, _coursePeriod);
    } else {
      context.read<CourseCubit>().addCourse(courseName, _coursePeriod, widget.yearId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      _courseNameController.text = widget.currentCourse!.courseName;
      _coursePeriod = widget.currentCourse!.coursePeriod;
    }

    return AlertDialog(
      title: Text(widget.isEditing ? "Edit Course" : "Add Course"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _courseNameController,
            decoration: InputDecoration(hintText: "Course Name"),
          ),
          ClassPeriodSelector(
            onClassPeriodSelected: (selectedClass) {
              setState(() {
                _coursePeriod = selectedClass; // Update the selected course period
              });
            },
          ),
        ],
      ),
      actions: [
        if (widget.isEditing)
          Container(
            color: Colors.red,
            child: TextButton(
              onPressed: () {
                deleteButton(context);
              },
              child: Text("Delete"),
            ),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Dismiss"),
        ),
        TextButton(
          onPressed: () => _saveButton(context),
          child: Text("Save"),
        ),
      ],
    );
  }

  void deleteButton(BuildContext context) {
    context.read<CourseCubit>().deleteCourse(widget.currentCourse!.courseId, widget.yearId);
    Navigator.of(context).pop();
  }
}

