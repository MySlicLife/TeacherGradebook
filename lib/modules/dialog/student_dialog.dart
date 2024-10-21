import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // Import for RawKeyboardListener

import '../../storage/course/course.dart';
import '../../storage/school_year/year.dart';
import '../../storage/student/student.dart';
import '../../storage/student/student_cubit.dart';

class StudentDialog extends StatelessWidget {
  final Course currentCourse;
  final Year currentYear;
  final bool isEditing;
  final Student? currentStudent;

  const StudentDialog({
    super.key,
    required this.currentCourse,
    required this.currentYear,
    this.isEditing = false,
    this.currentStudent,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController studentController = TextEditingController(
      text: isEditing ? currentStudent?.studentName : '',
    );

    void saveButton(BuildContext context) {
      String studentName = studentController.text;
      List<int> courseIds = [currentCourse.courseId];

      if (isEditing && currentStudent != null) {
        context.read<StudentCubit>().editStudent(
              currentStudent!.id,
              studentName,
              courseIds,
              null,
              null,
              currentYear.id,
              currentCourse.courseId,
            );
      } else {
        context.read<StudentCubit>().addStudent(
              studentName,
              courseIds,
              currentYear.id,
              currentCourse.courseId,
              null,
              null,
            );
      }
      Navigator.of(context).pop();
    }

    void deleteStudent(BuildContext context) {
      context.read<StudentCubit>().deleteStudent(currentStudent!.id, currentYear.id, currentCourse.courseId);
      Navigator.of(context).pop();
    }
    return BlocBuilder<StudentCubit, StudentState>(builder: (studentContext, state) {
      if (state is StudentsLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return AlertDialog(
          title: Text(isEditing ? "Edit Student" : "Add Student"),
          content: KeyboardListener(
            focusNode: FocusNode()..requestFocus(), // Request focus
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  saveButton(context); // Call save on Enter
                } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                  Navigator.of(context).pop(); // Dismiss on Escape
                }
              }
            },
            child: TextField(
              controller: studentController,
              decoration: InputDecoration(labelText: "Student Name"),
            ),
          ),
          actions: [
                    if (isEditing) 
          Container(
            color: Colors.red,
            child: TextButton(
              onPressed: () {
              deleteStudent(context);
            }, child: Text("Delete"),),
          ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Dismiss"),
            ),
            TextButton(
              onPressed: () {
                saveButton(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      }
    });
  }
}
