
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../storage/assignment/assignment.dart';
import '../../storage/course/course.dart';
import '../../storage/grade/grade.dart';
import '../../storage/grade/grade_cubit.dart';
import '../../storage/student/student.dart';

class GradeDialog extends StatefulWidget {
  final List<Student> studentList;
  final Assignment assignment;
  final Course currentCourse;
  final int initialIndex;

  late final bool isMissing;
  late final bool isLate;
  late final bool isComplete;

  // ignore: prefer_const_constructors_in_immutables
  GradeDialog({
    super.key,
    required this.assignment,
    required this.studentList,
    required this.initialIndex,
    required this.currentCourse,
    this.isComplete = false,
    this.isLate = false,
    this.isMissing = false,
  });

  @override
  GradeDialogState createState() => GradeDialogState();
}

class GradeDialogState extends State<GradeDialog> {
  late int currentIndex;
  final TextEditingController _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _loadCurrentGrade();
  }

  void _loadCurrentGrade() {
    final currentStudent = widget.studentList[currentIndex];
    // Load the current grade from the database for the student
    // For example:
    final currentGrade = _getCurrentGradeForStudent(currentStudent);

    _gradeController.text = currentGrade?.getFormattedPointsEarned() ?? '';
  }

  Grade? _getCurrentGradeForStudent(Student student) {
    try {
      return student.grades.firstWhere(
        (grade) => grade.assignment.value?.id == widget.assignment.id,
      );
    } catch (e) {
      return null; // Return null if no matching grade is found
    }
  }

  void _nextStudent() {
    final currentStudent = widget.studentList[currentIndex];
    _updateGrade(currentStudent);

    if (currentIndex < widget.studentList.length - 1) {
      setState(() {
        currentIndex++;
        _loadCurrentGrade();
      });
    } else {
      _loadCurrentGrade();
      Navigator.of(context).pop();
    }
  }

  void _previousStudent() {
    final currentStudent = widget.studentList[currentIndex];
    _updateGrade(currentStudent);

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _loadCurrentGrade();
      });
    } else {
      _loadCurrentGrade();
      Navigator.of(context).pop();
    }
  }

  void _updateGrade(Student student) {
    final gradeText = _gradeController.text;
    double? pointsEarned =
        gradeText.isNotEmpty ? double.parse(gradeText) : null;
    
    // Clear grade controller
    _gradeController.text = "";
    // Retrieve the current grade for the student and assignment
    final currentGrade = _getCurrentGradeForStudent(student);

    // Logic to update the database
    if (pointsEarned != null) {
      // If pointsEarned is not null, add or edit the grade
      if (currentGrade == null) {
        // No grade exists, add a new grade
        BlocProvider.of<GradeCubit>(context).addGrade(pointsEarned,
            widget.assignment.maximumPoints, student.id, widget.assignment.id, widget.isComplete, widget.isLate, widget.isMissing);
      } else {
        // Grade exists, edit the existing grade
        BlocProvider.of<GradeCubit>(context).editGrade(currentGrade.id,
            pointsEarned, widget.assignment.maximumPoints, student.id, widget.isComplete, widget.isLate, widget.isMissing);
      }
    } else {
      // If pointsEarned is null and there was an existing grade, delete it
      if (currentGrade != null) {
        BlocProvider.of<GradeCubit>(context).deleteGrade(
          currentGrade.id,
          student.id,
        );
      }
    }
  }

  void _closeDialog() {
    final currentStudent = widget.studentList[currentIndex];
    _updateGrade(currentStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final Student currentStudent = widget.studentList[currentIndex];
    final FocusNode focusNode = FocusNode();
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          //Go next on right arrow
          if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.tab) {
            _nextStudent();
            //Go previous on left arrow
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _previousStudent();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            _closeDialog();
          }
        }
      },
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _closeDialog,
              icon: Icon(Icons.close),
              color: Colors.red,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentStudent.studentName),
                Text(widget.assignment.assignmentName),
              ],
            ),
            Column(
              children: [
                Text(widget.currentCourse.courseName),
                Text(widget.currentCourse.coursePeriod),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousStudent,
                    icon: Icon(Icons.arrow_back),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 85,
                        child: TextField(
                          controller: _gradeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                          ],
                          decoration: InputDecoration(labelText: "Grade"),
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      Text("/ ${widget.assignment.getFormattedMaximumPoints()}",
                          style: TextStyle(fontSize: 40)),
                    ],
                  ),
                  IconButton(
                    onPressed: _nextStudent,
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_getCurrentGradeForStudent(currentStudent) != null) {
                       final currentIsMissing = _getCurrentGradeForStudent(currentStudent)!.isMissing;
                       widget.isMissing = !currentIsMissing!;
      
                      } else {
                        widget.isMissing = !widget.isMissing;
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.redAccent), // Missing button logic
                    child: Text("M", style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_getCurrentGradeForStudent(currentStudent) != null) {
                       final currentIsLate = _getCurrentGradeForStudent(currentStudent)!.isLate;
                       widget.isLate = !currentIsLate!;
                       
                      } else {
                        widget.isLate = !widget.isLate;
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent), // Late button logic
                    child: Text("L", style: TextStyle(color: Colors.black)),
                  ),
                  Container(
                    color: Colors.greenAccent,
                    child: IconButton(
                      onPressed: () {
                      
                      if (_getCurrentGradeForStudent(currentStudent) != null) {
                       final currentIsComplete = _getCurrentGradeForStudent(currentStudent)!.isComplete;
                       widget.isComplete = !currentIsComplete!;
                       
                      } else {
                        widget.isComplete = !widget.isComplete;
                      }
                    }, // Complete button logic
                      icon: Icon(Icons.check, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }
}
