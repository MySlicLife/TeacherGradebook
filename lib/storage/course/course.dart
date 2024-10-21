
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

  Course({required this.courseName, required this.coursePeriod});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && courseId == other.courseId;

  @override
  int get hashCode => courseId.hashCode;
}

