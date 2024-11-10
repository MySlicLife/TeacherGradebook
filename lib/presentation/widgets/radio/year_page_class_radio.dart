import 'package:flutter/material.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/text_button.dart';
import 'package:teacher_gradebook/storage/course/course.dart';
import 'package:teacher_gradebook/storage/school_year/year.dart';


class YearPageClassToggle extends StatefulWidget {
  final List<Course> courses;
  final void Function() onPressed;
  final void Function(Course?)? onOptionChanged; // Callback for selection changes
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
  Course? _selectedOption;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: NeumorphicTextButton(buttonText: "Year", onPressed: () {
              setState(() {
                _selectedOption = null;
                if (widget.onOptionChanged != null) {widget.onOptionChanged!(null);}
              });
            }, screenTheme: widget.screenTheme),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.courses.length,
                itemBuilder: (context, index) {
                  final courseInfo = widget.courses[index].courseName;
      
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: courseInfo,
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout();
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: textPainter.width + 45,
                      child: NeumorphicTextButton(
                        buttonText: courseInfo,
                        onPressed: () {
                          setState(() {
                            _selectedOption = widget.courses[index];
                          });
                          // Call the callback to notify the parent
                          if (widget.onOptionChanged != null) {widget.onOptionChanged!(_selectedOption);}
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
