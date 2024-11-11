import 'package:flutter/material.dart';

class NeumorphicIconButton extends StatelessWidget {
  final IconData buttonIcon;
  final ThemeData currentTheme; 
  final VoidCallback onPressed; 
  
  const NeumorphicIconButton({super.key, required this.onPressed, required this.currentTheme, required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentTheme.colorScheme.tertiary,      
        ),
      child: Icon(buttonIcon, color: currentTheme.colorScheme.onTertiary),
          ),
    );
  }
}