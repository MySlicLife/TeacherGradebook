
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../assignment/assignment.dart';
import '../school_year/year.dart';
import '../student/student.dart';

part 'course.g.dart';

@collection
class Course {
  Id courseId = Isar.autoIncrement; // Unique class ID

  late String courseName; // Name of course
  late String coursePeriod; // Course period

  final schoolYear = IsarLink<Year>(); // Link to school year

  @Backlink(to: 'courses')
  final assignments = IsarLinks<Assignment>(); // Backlink to assignments

  @Backlink(to: 'courses')
  final students = IsarLinks<Student>(); // Backlink to students

  late List<double> thresholds; //Map for the score that gets you what points

  Course({required this.courseName, required this.coursePeriod, required this.thresholds});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && courseId == other.courseId;

  @override
  int get hashCode => courseId.hashCode;

  // Method to get letter grade
  String getLetterGrade(double numericGrade) {
    if (numericGrade >= thresholds[0]) return 'A';
    if (numericGrade >= thresholds[1]) return 'B';
    if (numericGrade >= thresholds[2]) return 'C';
    if (numericGrade >= thresholds[3]) return 'D';
    if (numericGrade < thresholds[3]) return 'F';
    return 'N/A';
  }

      String getFormattedPointsEarned(double? pointsEarned) {
      if (pointsEarned == null) {
        return '';
      }
    NumberFormat format = NumberFormat('###.#');
    return format.format(pointsEarned);
  } 
}

