import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_gradebook/presentation/landing_page.dart';
import 'package:teacher_gradebook/presentation/theme/theme_cubit.dart';
import 'package:teacher_gradebook/storage/settings/settings_storage.dart';
import 'package:teacher_gradebook/storage/student/student.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/update_checker/update_checker.dart';
import 'storage/assignment/assignment.dart';
import 'storage/course/course.dart';
import 'storage/grade/grade.dart';
import 'storage/school_year/year.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  // Make it take up whole screen
  windowManager.setPosition(Offset.zero);
  windowManager.setSize(Size(1750, 950));
  windowManager.setMinimumSize(Size(1750, 950));

  //Create cubits
  final settingsCubit = SettingsCubit();
  final themeCubit = ThemeCubit(settingsCubit: settingsCubit);

  await settingsCubit.loadSettings();

  //debugPaintSizeEnabled = true;
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
      [YearSchema, CourseSchema, AssignmentSchema, StudentSchema, GradeSchema],
      directory: dir.path);
  Logger.init();
  Logger.logMessage(dir.path);
  runApp(MultiBlocProvider(
    providers: [
        BlocProvider<SettingsCubit>(create: (_) => settingsCubit),
        BlocProvider<ThemeCubit>(create: (_) => themeCubit),
      ],
    child: MyApp(isar: isar),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required Isar isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LandingPage());
  }
}
