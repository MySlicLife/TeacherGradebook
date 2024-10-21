

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/modules/dialog/course_dialog.dart';

import '../../presentation/theme/colors.dart';
import '../../storage/school_year/year.dart';
import '../../storage/school_year/year_cubit.dart';
import 'color_picker_dialog.dart';

class SchoolYearDialog extends StatefulWidget {
  final String? previousYear;
  final Year? currentYear; //Pass current year for editing
  final bool isEditing;

  const SchoolYearDialog({
    super.key,
    this.previousYear,
    this.currentYear,
    this.isEditing = false,
  });

  @override
  SchoolYearDialogState createState() => SchoolYearDialogState();
}

class SchoolYearDialogState extends State<SchoolYearDialog> {
  final _yearController = TextEditingController();
  late Color selectedColor;
  late int colorId;

  @override
  void initState() {
    super.initState();
    selectedColor =
        Color(widget.currentYear?.yearColorInt ?? AvailableColors.colors[0].value);
    colorId = widget.currentYear?.yearColorId ?? 0;
    if (widget.isEditing) {
      _yearController.text = widget.previousYear ?? '';
    }
  }

  void _saveButton(BuildContext context) {
    String yearName = _yearController.text;
    if (widget.isEditing && widget.currentYear?.id != null) {
      context.read<YearCubit>().editYear(
          widget.currentYear!.id, yearName, selectedColor.value, colorId);
    } else {
      context.read<YearCubit>().addYear(yearName, selectedColor.value, colorId);
    }
    Navigator.of(context).pop();
  }

  void _addClass() {
    showDialog(
      context: context,
      builder: (context) => CourseDialog(
        yearId: widget.currentYear!.id,
        isEditing: false,
      ),
    );
  }

  void _addPeriodType() {
    // Implement your period type adding logic here
  }

  void _openColorPicker() async {
    final colorPickerResult = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ColorPickerDialog(
        availableColors: AvailableColors.colors,
        currentColor: selectedColor,
      ),
    );

    if (colorPickerResult != null) {
      Color newColor = colorPickerResult['color']; // Access the selected color
      int newColorId = colorPickerResult['colorId']; // Access the color ID
      setState(() {
        selectedColor = newColor; // Update the state with the new color
        colorId = newColorId; //Update state with new color ID
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YearCubit, YearState>(
      builder: (context, state) {
        if (state is YearsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is YearsLoaded) {
          return AlertDialog(
            title:
                Text(widget.isEditing ? "Edit school year" : "Add school year"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year Name Textbox
                Center(
                    child: TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                )),

                // Period Type Selector
                Row(
                  children: [
                    // Dropdown of period types
                    Container(
                      height: 50,
                      width: 100,
                      color: Colors.amber,
                    ),
                    // Add Button
                    IconButton(
                      onPressed: _addPeriodType,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),

                // Color Picker
                GestureDetector(
                  onTap: _openColorPicker,
                  child: Container(
                    height: 50,
                    width: 200,
                    color: selectedColor,
                  ),
                ),

                // Classes Dropdown
                Row(
                  children: [
                    // Dropdown of classes
                    // Add Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: _addClass,
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Dismiss Dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Dismiss"),
              ),
              // Save Button
              TextButton(
                onPressed: () => _saveButton(context),
                child: Text("Save"),
              ),
            ],
          );
        } else {
          throw Exception("Unknown State");
        }
      },
    );
  }
}
