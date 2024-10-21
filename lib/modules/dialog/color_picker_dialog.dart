
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color currentColor;
  final List<Color> availableColors;

  const ColorPickerDialog({super.key, required this.currentColor, required this.availableColors});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = currentColor; // Use a local variable for selection
    int colorId = availableColors.indexOf(selectedColor); // Initialize colorId

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
              Navigator.of(context).pop({'color': selectedColor, 'colorId': colorId}); // Return selected color
            },
            child: Text("Select"),
          ),
        ],
      ),
    );
  }
}

