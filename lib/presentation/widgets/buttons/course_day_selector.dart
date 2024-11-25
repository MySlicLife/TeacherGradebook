import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class CourseDaySelector extends StatefulWidget {
  final bool isA;
  final bool isDarkMode;
  final ThemeData courseTheme;
  final Function(String) onPeriodSelected; // Callback to notify parent

  CourseDaySelector({
    required this.isA,
    required this.courseTheme,
    required this.isDarkMode,
    required this.onPeriodSelected, // Initialize the callback
  });

  @override
  _CourseDaySelectorState createState() => _CourseDaySelectorState();
}

class _CourseDaySelectorState extends State<CourseDaySelector> {
  late String selectedPeriod; // Declare this as a class-level variable
  Offset distance = Offset(7, 7);
  double blur = 7;

  @override
  void initState() {
    super.initState();
    // Initialize selectedPeriod based on the widget.isA value
    selectedPeriod = widget.isA ? "A" : "B";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Custom button segment for "A"
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedPeriod = "A";
              });
              widget.onPeriodSelected(selectedPeriod); // Notify the parent widget
            },
            child: AspectRatio(
              aspectRatio: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.courseTheme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: selectedPeriod == "A"
                      ? widget.isDarkMode
                          ? [
                              BoxShadow(
                                blurRadius: blur,
                                offset: distance, // Negative offset
                                color: widget.courseTheme.colorScheme.surface,
                                inset: true,
                              ),
                              BoxShadow(
                                blurRadius: blur,
                                offset: -distance, // Negative offset
                                color: widget.courseTheme.colorScheme.secondary,
                                inset: true,
                              )
                            ]
                          : [
                              BoxShadow(
                                blurRadius: blur,
                                offset: -distance, // Negative offset
                                color: widget.courseTheme.colorScheme.secondary,
                                inset: true,
                              ),
                              BoxShadow(
                                blurRadius: blur,
                                offset: distance, // Negative offset
                                color: widget.courseTheme.colorScheme.onPrimary,
                                inset: true,
                              )
                            ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                      color: widget.courseTheme.colorScheme.onTertiary,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Custom button segment for "B"
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedPeriod = "B";
              });
              widget.onPeriodSelected(selectedPeriod); // Notify the parent widget
            },
            child: AspectRatio(
              aspectRatio: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.courseTheme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: selectedPeriod == "B"
                      ? widget.isDarkMode
                          ? [
                              BoxShadow(
                                blurRadius: blur,
                                offset: distance, // Negative offset
                                color: widget.courseTheme.colorScheme.surface,
                                inset: true,
                              ),
                              BoxShadow(
                                blurRadius: blur,
                                offset: -distance, // Negative offset
                                color: widget.courseTheme.colorScheme.secondary,
                                inset: true,
                              )
                            ]
                          : [
                              BoxShadow(
                                blurRadius: blur,
                                offset: -distance, // Negative offset
                                color: widget.courseTheme.colorScheme.secondary,
                                inset: true,
                              ),
                              BoxShadow(
                                blurRadius: blur,
                                offset: distance, // Negative offset
                                color: widget.courseTheme.colorScheme.onPrimary,
                                inset: true,
                              )
                            ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "B",
                    style: TextStyle(
                      color: widget.courseTheme.colorScheme.onTertiary,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
