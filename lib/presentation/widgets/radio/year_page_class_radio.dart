import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/text_button.dart';
import 'package:teacher_gradebook/storage/course/course.dart';
import 'package:teacher_gradebook/storage/school_year/year.dart';

class YearPageClassToggle extends StatefulWidget {
  final List<Course> courses;
  final void Function() onPressed;
  final void Function(List<Course>?)? onOptionChanged; // Callback for selection changes
  final ThemeData screenTheme;
  final Year? selectedYear;

  const YearPageClassToggle({
    super.key,
    required this.courses,
    required this.onPressed,
    required this.onOptionChanged, // Add this line
    required this.screenTheme,
    this.selectedYear,
  });

  @override
  State<YearPageClassToggle> createState() => _YearPageClassToggleState();
}

class _YearPageClassToggleState extends State<YearPageClassToggle> {

  @override
  Widget build(BuildContext context) {
    // Group the courses by course name
    var groupedCourses = groupBy(widget.courses, (Course course) => course.courseName);

    // Convert groupedCourses to a list of course names and their list of courses
    List<MapEntry<String, List<Course>>> groupedEntries = groupedCourses.entries.toList();

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: NeumorphicTextButton(
              buttonText: "Year",
              onPressed: () {
                setState(() {
                  if (widget.onOptionChanged != null) {
                    widget.onOptionChanged!(null);
                  }
                });
              },
              screenTheme: widget.screenTheme,
            ),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: groupedEntries.length, // Number of unique course names
                itemBuilder: (context, index) {
                  final courseName = groupedEntries[index].key;
                  final coursesList = groupedEntries[index].value;

                  // Text measurement for width calculation
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: courseName,
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: textPainter.width + 45, // Add padding
                      child: NeumorphicTextButton(
                        buttonText: courseName,
                        onPressed: () {

                          // Notify parent of the course selection
                          if (widget.onOptionChanged != null) {
                            widget.onOptionChanged!(coursesList);
                          }

                          print(coursesList.length);
                        },
                        screenTheme: widget.screenTheme,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 100,
            child: NeumorphicTextButton(
              buttonText: "Add",
              onPressed: widget.onPressed,
              screenTheme: widget.screenTheme,
            ),
          ),
        ],
      ),
    );
  }
}
