import 'package:flutter/material.dart';

import '../../../storage/course/course.dart';
import '../../../storage/school_year/year.dart';

class GradeBreakdown extends StatefulWidget {
  final List<Course>? selectedCourseList;
  final Year? selectedYear;
  final ThemeData screenTheme;

  const GradeBreakdown(
      {super.key,
      this.selectedCourseList,
      this.selectedYear,
      required this.screenTheme,});

  @override
  State<GradeBreakdown> createState() => _GradeBreakdownState();
}

class _GradeBreakdownState extends State<GradeBreakdown> {
  @override
  Widget build(BuildContext context) {
    // Initialize the map to count grades
    final Map<String, int> gradeCountMap = {
      "A": 0,
      "B": 0,
      "C": 0,
      "D": 0,
      "F": 0,
      "N/A": 0
    };

    if (widget.selectedCourseList != null) {
      // Count grades just for the course
      for (var course in widget.selectedCourseList!) {
      for (var student in course.students) {
        String letterGrade =
            student.studentLetterGrade ?? "N/A"; // Assuming this is a string
        if (gradeCountMap.containsKey(letterGrade)) {
          // Increment the count for the grade
          gradeCountMap[letterGrade] = gradeCountMap[letterGrade]! + 1;
        }
      }
      }
    } else if (widget.selectedYear != null) {
      // Count grades for the whole year
      for (var course in widget.selectedYear!.courses) {
        for (var student in course.students) {
          String letterGrade = student.studentLetterGrade ?? "N/A";
          if (gradeCountMap.containsKey(letterGrade)) {
            gradeCountMap[letterGrade] = gradeCountMap[letterGrade]! + 1;
          }
        }
      }
    } else {
      List<String> dummyGrades = [
        "A", "B", "C", "A", "D", "B", "C", "A", "F", "C",
        "B", "D", "A", "C", "F", "B", "A", "C", "D", "F",
        "B", "A", "C", "D", "A", "B", "C", "F", "B", "A"
      ];

      for (String grade in dummyGrades) {
        String letterGrade = grade;
        if (gradeCountMap.containsKey(letterGrade)) {
          gradeCountMap[letterGrade] = gradeCountMap[letterGrade]! + 1;
        }
      }
    }

    // Calculate maxValue safely
    final double maxValue = gradeCountMap.values.reduce((a, b) => a > b ? a : b).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Available width minus padding for labels and margins
        final double availableWidth = constraints.maxWidth - 60;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.selectedCourseList?[0].courseName ?? widget.selectedYear?.year ?? "Example"} Grades",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.screenTheme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 10),

            // Create a row for each entry in the data map
            for (int index = 0; index < gradeCountMap.length; index++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Bar label
                    SizedBox(
                      width: 40,
                      child: Text(
                        gradeCountMap.entries.toList()[index].key,
                        style: TextStyle(
                          color: widget.screenTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    // Bar itself
                    Container(
                      width: maxValue > 0
                          ? (gradeCountMap.entries.toList()[index].value / maxValue) * availableWidth
                          : 0, // Scale the width relative to the available width
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: widget.screenTheme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(width: 10), // Spacing between bar and value
                    // Display the value at the end of the bar
                    Text(
                      gradeCountMap.entries.toList()[index].value.toString(),
                      style: TextStyle(
                        color: widget.screenTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
