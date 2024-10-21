

import 'package:isar/isar.dart';

import '../course/course.dart';

part 'year.g.dart';

@collection
class Year {
  Id id = Isar.autoIncrement; //School year Id
  late String year; //School year
  late int yearColorInt;
  late int yearColorId;
  

  @Backlink(to: 'schoolYear')
  final courses = IsarLinks<Course>();

  Year({required this.year, required this.yearColorInt, required this.yearColorId});

}