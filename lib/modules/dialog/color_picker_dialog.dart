
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:teacher_gradebook/presentation/theme/colors.dart';

class ColorPickerDialog extends StatelessWidget {
  final int yearColorId;
  final List<Color> availableColors;

  const ColorPickerDialog({super.key, required this.yearColorId, required this.availableColors});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = AvailableColors.colors[yearColorId]; // Use a local variable for selection
    int colorId = yearColorId; // Initialize colorId

    return AlertDialog(
      title: Text("Select Color"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlockPicker(
            availableColors: availableColors,
            pickerColor: selectedColor,
            onColorChanged: (Color color) {
              selectedColor = color; // Update the local variable
              colorId = availableColors.indexOf(color); // Update the colorId
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(colorId); // Return selected color
            },
            child: Text("Select"),
          ),
        ],
      ),
    );
  }
}

