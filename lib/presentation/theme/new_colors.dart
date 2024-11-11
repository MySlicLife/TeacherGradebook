import 'package:flutter/material.dart';

class AvailableColors {
  static const List<Color> colors = [
    Color.fromARGB(255, 189, 189, 189), //Grey
    Color.fromARGB(255, 255, 209, 220), //Pink
    Color.fromARGB(255, 255, 105, 197), //Red
    Color.fromARGB(255, 177, 156, 217), //Purple
    Color.fromARGB(255, 179, 235, 242), //Blue
    Color.fromARGB(255, 128, 239, 128), //Green
    Color.fromARGB(255, 255, 239, 144), //Yellow
    Color.fromARGB(255, 255, 153, 85), //Orange
  ];
}

//Default Values that dont change
final Color error = Color.fromARGB(255, 176, 0, 32);
final Color darkError = Color.fromARGB(255, 207, 102, 121);

class GreyTheme {
  int colorThemeId = 0;
  //Light Mode
  ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 158, 158, 158),
      onPrimary: Color.fromARGB(255, 245, 245, 245),
      surface: Color.fromARGB(255, 224, 224, 224),
      onSurface: Color.fromARGB(255, 66, 66, 66),
      error: error,
      onError: Color.fromARGB(255, 224, 224, 224),

)
  );
  //Dark Mode
  ThemeData darkMode = ThemeData(

  );
}