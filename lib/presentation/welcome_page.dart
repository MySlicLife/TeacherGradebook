import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../modules/dialog/year_dialog.dart';
import '../storage/course/course_cubit.dart';
import '../storage/school_year/year_cubit.dart';
import '../storage/teacher_repo.dart';
import 'theme/theme_cubit.dart';
import 'year_page.dart';

class WelcomePage extends StatefulWidget {
  final String teacherName;

  const WelcomePage({super.key, required this.teacherName});

  static bool enableEditing = false;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    context.read<YearCubit>().loadYears();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (themeContext, welcomeThemeState) {
        return Scaffold(
          backgroundColor: welcomeThemeState.primaryColor,
          body: Column(
            children: [
              // Introduction
              Text(
                "Hello, ${widget.teacherName}",
                style: TextStyle(fontSize: 50),
              ),

              // Select Year
              Text(
                "Select a Year Below...",
                style: TextStyle(fontSize: 40),
              ),

              TextButton(onPressed: () {
                themeCubit.toggleTheme();
              }, child: Text("Toggle Dark Mode")),

              // Year tile
              BlocBuilder<YearCubit, YearState>(
                builder: (context, yearState) {
                  if (yearState is YearsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (yearState is YearsLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: yearState.schoolYears.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              color: () {
                                        var theme =
                                            themeCubit.colorThemes.firstWhere(
                                          (theme) =>
                                              theme.colorThemeId ==
                                              yearState.schoolYears[index]
                                                  .yearColorId,
                                        );
                                        var selectedThemeData =
                                            themeCubit.isDarkMode
                                                ? theme.darkMode
                                                : theme.lightMode;
                                        return selectedThemeData.colorScheme
                                            .primary; // Return the color directly
                                      }(),
                              width: 400,
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (actionContext) {
                                        showDialog(
                                          context: actionContext,
                                          builder: (context) =>
                                              SchoolYearDialog(
                                            previousYear: yearState
                                                .schoolYears[index].year,
                                            currentYear:
                                                yearState.schoolYears[index],
                                            isEditing: true,
                                          ),
                                        );
                                      },
                                      icon: Icons.edit,
                                      backgroundColor: Colors.orange,
                                    ),
                                    SlidableAction(
                                      onPressed: (actionContext) {
                                        context.read<YearCubit>().deleteYear(
                                            yearState.schoolYears[index].id);
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      yearState.schoolYears[index].year,
                                      style: TextStyle(color: (() {
                                        var theme =
                                            themeCubit.colorThemes.firstWhere(
                                          (theme) =>
                                              theme.colorThemeId ==
                                              yearState.schoolYears[index]
                                                  .yearColorId,
                                        );
                                        var selectedThemeData =
                                            themeCubit.isDarkMode
                                                ? theme.darkMode
                                                : theme.lightMode;
                                        return selectedThemeData.colorScheme
                                            .inversePrimary; // Return the color directly
                                      })()),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (pageContext) =>
                                            MultiBlocProvider(
                                          providers: [
                                            BlocProvider(
                                              create: (context) =>
                                                  CourseCubit(TeacherRepo()),
                                            ),
                                            BlocProvider(
                                                create: (context) =>
                                                    ThemeCubit()),
                                          ],
                                          child: YearPage(
                                            year: yearState.schoolYears[index],
                                            yearThemeId: yearState
                                                .schoolYears[index].yearColorId,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  tileColor: Color(yearState
                                      .schoolYears[index].yearColorInt),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Center(child: Text("No Data Available"));
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SchoolYearDialog(),
              );
            },
            child: Icon(Icons.add),
          ), // Add Year
        );
      },
    );
  }
}
