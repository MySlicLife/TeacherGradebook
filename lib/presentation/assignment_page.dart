import 'package:flutter/material.dart';

import '../storage/assignment/assignment.dart';
import '../storage/course/course.dart';
import '../storage/school_year/year.dart';


class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key, required this.currentCourse, required this.currentYear, required this.currentAssignment});
  final Course currentCourse; 
  final Year currentYear;
  final Assignment currentAssignment;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Title
          Row(
            children: [

            Text("${currentCourse.coursePeriod} ${currentCourse.courseName} ${currentYear.year}"),
            Text(currentAssignment.assignmentName)
          ],),
          //Statistics
          //* Return statistics
          //* Following statistics will be recorded
          //*Highest grade (student), Lowest Grade (student), Average Grade, Median Grade, Standard Deviation
          //Listview.builder
          //* The return value will be something like the following
          //* Row (Student tile (Tappable), Grade, Comment (Textfield))
        ],
      )
    );
  }
}