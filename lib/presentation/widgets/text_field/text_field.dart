import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NeumorphicTextField extends StatelessWidget {
  final ThemeData? fieldTheme;
  final ThemeData screenTheme;
  final String hintText;
  final double cursorHeight;
  final TextEditingController textController;
  final double fontSize; 
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const NeumorphicTextField({super.key, this.focusNode, this.fieldTheme, required this.hintText, required this.textController, required this.screenTheme, required this.fontSize, this.onChanged, required this.cursorHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: fieldTheme?.colorScheme.tertiary ?? screenTheme.colorScheme.tertiary,
        ),
        child: Center(
          child: TextField(
            focusNode: focusNode,
            onChanged: onChanged,
            cursorColor: screenTheme.colorScheme.onTertiary,
            cursorHeight: cursorHeight,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              color: screenTheme.colorScheme.onTertiary
            ),
          controller: textController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: screenTheme.colorScheme.onTertiary
            ),
            
          ),
                ),
        ),),
    );
  }
}
