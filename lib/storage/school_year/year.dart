

import 'package:isar/isar.dart';

import '../course/course.dart';

part 'year.g.dart';

@collection
class Year {
  Id id = Isar.autoIncrement; //School year Id
  late String year; //School year
  late int yearColorId; //Year theme ID
  
  late DateTime startDate; //Year start date
  late DateTime endDate; //Year end date

  late String schoolName; //Name of the school
  late String location; //Name of location


  @Backlink(to: 'schoolYear')
  final courses = IsarLinks<Course>();

  Year({required this.year, required this.yearColorId, required this.startDate, required this.endDate, required this.location, required this.schoolName});

}