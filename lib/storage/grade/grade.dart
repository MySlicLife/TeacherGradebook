


import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../assignment/assignment.dart';
import '../student/student.dart';

part 'grade.g.dart';

@collection
class Grade {
  Id id = Isar.autoIncrement; //ID for specific grade

  late double? pointsEarned; //Points earned by student
  late double? pointsPossible; //Total Points

  final assignment = IsarLink<Assignment>(); //Link to assignment
  final student = IsarLink<Student>(); //Link to student

  bool? isLate; //Mark assignment as late
  bool? isMissing; //Mark assignment as missing
  bool? isComplete; //Mark assignment as complete

  Grade({this.pointsEarned, required this.pointsPossible, this.isLate, this.isMissing, this.isComplete});

    String getFormattedPointsEarned() {
      if (pointsEarned == null) {
        return '';
      }
    NumberFormat format = NumberFormat('###.#');
    return format.format(pointsEarned);
  } 
}
