import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/checkbox/checkbox_cubit.dart';
import '../../helpers/checkbox/course_checkbox_widget.dart';
import '../../storage/assignment/assignment_cubit.dart';
import '../../storage/course/course.dart';
import '../../storage/school_year/year.dart';
import '../../storage/assignment/assignment.dart';

class AssignmentDialog extends StatelessWidget {
  final List<Course> courseList;
  final Year currentYear;
  final Course currentCourse;
  final Assignment? existingAssignment;
  final bool isEditing;
  final AssignmentCubit assignmentCubit;

  const AssignmentDialog({
    super.key,
    required this.courseList,
    required this.currentCourse,
    required this.currentYear,
    this.existingAssignment,
    this.isEditing = false,
    required this.assignmentCubit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController assignmentNameController =
        TextEditingController(text: isEditing ? existingAssignment?.assignmentName : '');
    final TextEditingController maximumPointsController =
        TextEditingController(text: isEditing ? existingAssignment?.maximumPoints.toString() : '');

    void saveButton() {
      String assignmentName = assignmentNameController.text;
      String maximumPoints = maximumPointsController.text;

      final selectedCourses = context.read<CheckboxCubit<Course>>().state;

      // Handle adding or editing the assignment
      if (assignmentName.isNotEmpty && selectedCourses.isNotEmpty && maximumPoints.isNotEmpty) {
        if (isEditing && existingAssignment != null) {
          assignmentCubit.editAssignment(
            existingAssignment!.id,
            assignmentName,
            selectedCourses,
            double.parse(maximumPoints),
            currentCourse.courseId,
            currentYear.id,
          );
        } else {
          assignmentCubit.addAssignment(
            assignmentName,
            selectedCourses,
            double.parse(maximumPoints),
            currentCourse.courseId,
            currentYear.id,
          );
        }

        // Clear input fields and selections
        assignmentNameController.clear();
        maximumPointsController.clear();

        // Dismiss Dialog
        Navigator.of(context).pop();
      } else {
        String message = "";
        if (assignmentName.isEmpty) {
          message = "Please give the assignment a name.";
        } else if (selectedCourses.isEmpty) {
          message = "Please select at least one course.";
        } else if (maximumPoints.isEmpty) {
          message = "Please specify the maximum points.";
        }

        // Show SnackBar with the error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 5),
        ));
      }
    }

    void deleteButton() {
      assignmentCubit.deleteAssignment(existingAssignment!.id, currentCourse.courseId, currentYear.id);
      Navigator.of(context).pop();
    }
    return AlertDialog(
      title: Text(isEditing ? "Edit Assignment" : "Add Assignment"),
      content: KeyboardListener(
        focusNode: FocusNode()..requestFocus(), // Request focus
        onKeyEvent: (event) {
          if (event is KeyboardListener) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              saveButton(); // Call the save button method
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(context).pop(); // Dismiss the dialog
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: assignmentNameController,
                decoration: InputDecoration(labelText: "Assignment Title"),
              ),
              TextField(
                controller: maximumPointsController,
                decoration: InputDecoration(labelText: "Maximum Points"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                ],
              ),
              Text("Select courses..."),
              SizedBox(
                width: 200,
                child: CourseCheckboxList(
                  list: courseList,
                  selectedCourses: existingAssignment?.courses.toList() ?? [],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (isEditing) 
          Container(
            color: Colors.red,
            child: TextButton(
              onPressed: () {
              deleteButton();
            }, child: Text("Delete"),),
          ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: Text("Dismiss"),
        ),
        TextButton(
          onPressed: () {
            saveButton(); // Call the save button method
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
