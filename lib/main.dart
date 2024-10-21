import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_gradebook/presentation/landing_page.dart';
import 'package:teacher_gradebook/storage/student/student.dart';

import 'helpers/update_checker/update_checker.dart';
import 'storage/assignment/assignment.dart';
import 'storage/course/course.dart';
import 'storage/grade/grade.dart';
import 'storage/school_year/year.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //debugPaintSizeEnabled = true;
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
      [YearSchema, CourseSchema, AssignmentSchema, StudentSchema, GradeSchema],
      directory: dir.path);
  Logger.init();
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required Isar isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage());
  }
}
