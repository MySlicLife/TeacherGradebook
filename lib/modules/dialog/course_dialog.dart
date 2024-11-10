import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:teacher_gradebook/helpers/checkbox/period_checkbox.dart';
import 'package:teacher_gradebook/helpers/update_checker/update_checker.dart';

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
  String _coursePeriod = '';

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.currentCourse != null) {
      _courseNameController.text = widget.currentCourse!.courseName;
      _coursePeriod = widget.currentCourse!.coursePeriod;

      final thresholds = widget.currentCourse!.thresholds;
      for (int i = 0; i < thresholds.length && i < _controllers.length; i++) {
        _controllers[i].text =
            widget.currentCourse!.getFormattedPointsEarned(thresholds[i]);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _saveButton(BuildContext context) {
    String courseName = _courseNameController.text;
    List<double> thresholds = [];
    bool allFilled = true;

    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        allFilled = false;
        break;
      }
    }

    if (!allFilled) {
      _showErrorDialog('Please fill in all grade thresholds.'); // Show error dialog
      return; // Exit the method to prevent saving
    }

    for (var controller in _controllers) {
      try {
        double value = double.parse(controller.text);
        thresholds.add(value);
      } catch (e) {
        Logger.logMessage("Error parsing ${controller.text} to double: $e");
      }
    }

    if (widget.isEditing && widget.currentCourse != null) {
      context.read<CourseCubit>().editCourse(
          widget.currentCourse!.courseId,
          widget.yearId,
          courseName,
          _coursePeriod,
          thresholds,
      );
    } else {
      context.read<CourseCubit>().addCourse(courseName, _coursePeriod, widget.yearId, thresholds);
    }
    Navigator.of(context).pop();
  }

  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? "Edit Course" : "Add Course"),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(hintText: "Course Name"),
            ),
            ClassPeriodSelector(
              currentPeriod: widget.currentCourse?.coursePeriod,
              onClassPeriodSelected: (selectedClass) {
                setState(() {
                  _coursePeriod = selectedClass;
                });
              },
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  List<String> letterGrades = ['A', 'B', 'C', 'D', 'F'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(letterGrades[index], style: TextStyle(fontSize: 20)),
                        SizedBox(width: 50),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Grade',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
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
    context
        .read<CourseCubit>()
        .deleteCourse(widget.currentCourse!.courseId, widget.yearId);
    Navigator.of(context).pop();
  }
}

