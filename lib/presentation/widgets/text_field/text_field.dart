import 'package:flutter/material.dart';

class NeumorphicTextField extends StatelessWidget {
  final ThemeData? fieldTheme;
  final ThemeData screenTheme;
  final String hintText;
  final double cursorHeight;
  final TextEditingController textController;
  final double fontSize; 
  final void Function(String)? onChanged;
  

  const NeumorphicTextField({super.key, this.fieldTheme, required this.hintText, required this.textController, required this.screenTheme, required this.fontSize, this.onChanged, required this.cursorHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: fieldTheme?.colorScheme.inversePrimary ?? screenTheme.colorScheme.inversePrimary,
        ),
        child: Center(
          child: TextField(
            onChanged: onChanged,
            cursorColor: screenTheme.colorScheme.primary,
            cursorHeight: cursorHeight,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              color: screenTheme.colorScheme.primary
            ),
          controller: textController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: screenTheme.colorScheme.primary
            ),
            
          ),
                ),
        ),),
    );
  }
}
