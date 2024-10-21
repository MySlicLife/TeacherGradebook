

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../grade/grade.dart';
import '../course/course.dart';

part 'assignment.g.dart';

@collection
class Assignment {
  Id id = Isar.autoIncrement; //Assignment Id

  late String assignmentName; //Assignment's Name
  late double maximumPoints;

  @Backlink(to: "assignment")
  final grades = IsarLinks<Grade>(); //Backlink assignment to grades

  final courses = IsarLinks<Course>(); //link to courses assignment is attached to

  Assignment({required this.assignmentName, required this.maximumPoints});

  String getFormattedMaximumPoints() {
    NumberFormat format = NumberFormat('###.#');
    return format.format(maximumPoints);
  }

}