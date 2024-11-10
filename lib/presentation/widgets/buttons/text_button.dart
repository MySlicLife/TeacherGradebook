import 'package:flutter/material.dart';

class NeumorphicTextButton extends StatelessWidget {
  final String buttonText;
  final ThemeData? buttonTheme;
  final ThemeData screenTheme; 
  final Color? buttonColor;
  final VoidCallback onPressed; 
  
  const NeumorphicTextButton({super.key, required this.buttonText, required this.onPressed, this.buttonTheme, this.buttonColor, required this.screenTheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonTheme?.colorScheme.inversePrimary ?? buttonColor ?? screenTheme.colorScheme.inversePrimary,
      
        ),
      child: Center(child: Text(buttonText, style: TextStyle(color: buttonTheme?.colorScheme.primary ?? screenTheme.colorScheme.primary, fontSize: 17),)),),
    );
  }
}
