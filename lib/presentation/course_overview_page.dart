import 'package:flutter/material.dart';

import '../storage/course/course.dart';

class CourseOverviewPage extends StatefulWidget {
  Course selectedCourse;
  
  CourseOverviewPage({super.key, required this.selectedCourse});

  @override
  State<CourseOverviewPage> createState() => _CourseOverviewPageState();
}

class _CourseOverviewPageState extends State<CourseOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.selectedCourse.courseName);
  }
}