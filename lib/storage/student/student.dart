

import 'package:isar/isar.dart';

import '../grade/grade.dart';
import '../course/course.dart';

part 'student.g.dart';

@collection
class Student {
  Id id = Isar.autoIncrement; //Assign Program ID to student
  late int? studentId; //Student ID provided to by school
  late int? programId; //ID given to student by program school uses

  late String studentName; //Student's first and last name
  
  final courses = IsarLinks<Course>(); //Link to course

  @Backlink(to: "student")
  final grades = IsarLinks<Grade>(); //Backlink to grades

  

  Student({required this.studentName, this.studentId, this.programId});
}