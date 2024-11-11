/*

================================================================================================================================================================================================================================================
COLOR USE GUIDE FOR IDIOTS LIKE ALEKS
================================================================================================================================================================================================================================================
----------------------------
SURFACE
----------------------------
Usage: Backgrounds for cards, dialogs, or sections of the UI where content is displayed.
Example: Use for the background of your main content areas, such as a card or a scaffold's body.

----------------------------
PRIMARY
----------------------------
Usage: Main action buttons, app bar background, and any other elements that should stand out and attract attention.
Example: Use for primary buttons, floating action buttons (FAB), and the main app bar color.

----------------------------
secondary
----------------------------
Usage: secondary actions or elements that need to be visible but are less critical than primary elements.
Example: Use for secondary buttons or less emphasized elements like borders, dividers, or toggle switches.

----------------------------
tertiary
----------------------------
Usage: Subtle backgrounds, lighter surfaces, or less prominent UI elements that still need to be visible.
Example: Use for background shades of input fields, tooltips, or any additional layer of separation in the UI.

----------------------------
INVERSE PRIMARY
----------------------------
Usage: Text or icons on top of primary surfaces or elements that need to stand out against the primary background.
Example: Use for text on primary buttons, icons in the app bar, or any other situation where high contrast is required.


Want to add more colors?
Color Shade Generator: https://colorkit.co/color-shades-generator/72e5dd/
Color Screen Picker: https://pickcoloronline.com/
Chat GPT Prompt To Make the Code so you dont have to :)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Using the hex color I give you, create a shade and tint list 1 being lightest and 10 being darkest with 5 being the hex color I give you. Then convert all the values to ARGB with 255 for the A value. Dont print the list of Color.fromARGB lines, just print the code to copy. Also at the very end give the Color.fromARGB value for the color I gave you and with a comma a the end instead of a semi-colon

Then the commented numbers are which of the values 1-10 should belong to that number, make that number the color generated. Do not add any comments, you can take away the comments that I put in there to help you. 

Here is the code 

    ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color.fromARGB(255, 187, 212, 237), 
    primary: Color.fromARGB(255, 170, 201, 232), 
    secondary: Color.fromARGB(255, 212, 228, 244), 
    tertiary: Color.fromARGB(255, 229, 239, 248), 
    inversePrimary: Color.fromARGB(255, 45, 54, 64), 
  )
);

// Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 2, 1, 2), 
    primary: Color.fromARGB(255, 45, 54, 64),
    secondary: Color.fromARGB(255, 83, 100, 116), 
    tertiary: Color.fromARGB(255, 195, 217, 239), 
    inversePrimary: Color.fromARGB(255, 229, 239, 248), 
  )
);

Here is the Hex Value

 #156643
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
//Colors that are available for color pickers

import 'package:flutter/material.dart';

class AvailableColors {
  static const List<Color> colors = [
    Color(0xFFBDBDBD), //Grey
    Color(0xFFFFC6D3), //Pink
    Color(0xFFFF6E66), //Red
    Color(0xFFC3B1E1), //Purple
    Color.fromARGB(255, 185, 195, 208), //Light Blue
    Color.fromARGB(255, 43, 58, 87), //Blue
    Color.fromARGB(255, 208, 250, 207), //Light green
    Color.fromARGB(255, 21, 102, 67), // Dark Green
    Color.fromARGB(255, 255, 239, 144), //Yellow
    Color.fromARGB(255, 255, 153, 85), //Orange
  ];
}

//Default Values that dont change
final Color error = Color.fromARGB(255, 176, 0, 32);
final Color darkError = Color.fromARGB(255, 207, 102, 121);

class GreyTheme {
  Color seedColor = Color(0xFFBDBDBD);
  int colorThemeId = 0;
  ThemeData lightMode = ThemeData(
    primaryColor: Color(0xFFBDBDBD),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFE0E0E0), //300
      onSurface: Color(0xFF212121), //800
      primary: Color(0xFFcacaca), //400
      onPrimary: Color(0xFF212121), //800
      secondary: Color(0xFF9E9E9E), //500 
      onSecondary: Color(0xFF212121), //900
      tertiary: Color(0xFF757575), //600
      onTertiary: Color(0xFFEEEEEE), //200
      error: error,
      onError: Color(0xFFE0E0E0)
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFBDBDBD),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF212121), //800
      onSurface: Color(0xFFF5F5F5), //100
      primary: Color(0xFF616161), //700
      onPrimary: Color(0xFFF5F5F5), //100
      secondary: Color(0xFF757575), //600 
      onSecondary: Color(0xFFF5F5F5), //100
      tertiary: Color(0xFF9E9E9E), //500
      onTertiary: Color(0xFFF5F5F5), //100
      error: error,
      onError: Color(0xFFF5F5F5)
  ));
}

class PinkTheme {
  Color seedColor = Color(0xFFFFC6D3);
  int colorThemeId = 1;

  ThemeData lightMode = ThemeData(
    primaryColor: Color(0xFFFFC6D3),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFffe5ea), //300
      onSurface: Color(0xFF997f84), //800
      primary: Color(0xFFffd3dc), //400
      onPrimary: Color(0xFF332a2c), //800
      secondary: Color(0xFFcca9b0), //500 
      onSecondary: Color(0xFF332a2c), //900
      tertiary: Color(0xFF806a6e), //600
      onTertiary: Color(0xFFffe9ee), //200
      error: error,
      onError: Color(0xFFfff6f8) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFFFC6D3),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF332a2c), //800
      onSurface: Color(0xFFfff6f8), //100
      primary: Color(0xFF4c3f42), //700
      onPrimary: Color(0xFFfff2f5), //100
      secondary: Color(0xFF665458), //600 
      onSecondary: Color(0xFFffedf1), //100
      tertiary: Color(0xFF806a6e), //500
      onTertiary: Color(0xFFffe9ee), //100
      error: error,
      onError: Color(0xFFfff6f8) //50
  ));

  
}

class RedTheme {
  Color seedColor = Color(0xFFFF6E66);
  int colorThemeId = 2;

  ThemeData lightMode = ThemeData(
    primaryColor: Color(0xFFFF6E66),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFffd4d1), //300
      onSurface: Color(0xFF331614), //800
      primary: Color(0xFFffa8a3), //400
      onPrimary: Color(0xFF331614), //800
      secondary: Color(0xFFffb7b3), //500 
      onSecondary: Color(0xFF190b0a), //900
      tertiary: Color(0xFF662c29), //600
      onTertiary: Color(0xFFff8b85), //200
      error: error,
      onError: Color(0xFFffc5c2) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFFF6E66),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF331614), //800
      onSurface: Color(0xFFff7d75), //100
      primary: Color(0xFF4c211f), //700
      onPrimary: Color(0xFFff7d75), //100
      secondary: Color(0xFF662c29), //600 
      onSecondary: Color(0xFFff7d75), //100
      tertiary: Color(0xFF803733), //500
      onTertiary: Color(0xFFff7d75), //100
      error: error,
      onError: Color(0xFFffc5c2) //50
  ));
}

class PurpleTheme {
  Color seedColor = Color(0xFFC3B1E1);
  int colorThemeId = 3;

    ThemeData lightMode = ThemeData(
      primaryColor: Color(0xFFC3B1E1),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFede8f6), //300
      onSurface: Color(0xFF27232d), //800
      primary: Color(0xFFe1d8f0), //400
      onPrimary: Color(0xFF27232d), //800
      secondary: Color(0xFFcfc1e7), //500 
      onSecondary: Color(0xFF131216), //900
      tertiary: Color(0xFF9c8eb4), //600
      onTertiary: Color(0xFFede8f6), //200
      error: error,
      onError: Color(0xFFf3eff9) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFC3B1E1),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF27232d), //800
      onSurface: Color(0xFFf3eff9), //100
      primary: Color(0xFF4e475a), //700
      onPrimary: Color(0xFFede8f6), //100
      secondary: Color(0xFF756a87), //600 
      onSecondary: Color(0xFFe7e0f3), //100
      tertiary: Color(0xFFb09fcb), //500
      onTertiary: Color(0xFFf3eff9), //100
      error: error,
      onError: Color(0xFFf3eff9) //50
  ));
}

class LightBlueTheme {
  int colorThemeId = 4;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 229, 212, 244),
        primary: Color.fromARGB(255, 210, 189, 231),
        secondary: Color.fromARGB(255, 195, 177, 225),
        tertiary: Color.fromARGB(255, 175, 157, 205),
        inversePrimary: Color.fromARGB(255, 129, 109, 183),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 129, 109, 183),
        secondary: Color.fromARGB(255, 156, 134, 201),
        tertiary: Color.fromARGB(255, 210, 189, 231),
        inversePrimary: Color.fromARGB(255, 175, 157, 205),
      ));
}

class BlueTheme {
  int colorThemeId = 5;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 196, 214, 227),
        primary: Color.fromARGB(255, 110, 145, 176),
        secondary: Color.fromARGB(255, 48, 73, 100),
        tertiary: Color.fromARGB(255, 31, 45, 62),
        inversePrimary: Color.fromARGB(255, 45, 54, 64),
      ));

  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 2, 1, 2),
        primary: Color.fromARGB(255, 45, 54, 64),
        secondary: Color.fromARGB(255, 83, 100, 116),
        tertiary: Color.fromARGB(255, 195, 217, 239),
        inversePrimary: Color.fromARGB(255, 229, 239, 248),
      ));
}

class GreenTheme {
  int colorThemeId = 6;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 229, 255, 229),
        primary: Color.fromARGB(255, 218, 255, 218),
        secondary: Color.fromARGB(255, 208, 250, 207),
        tertiary: Color.fromARGB(255, 198, 245, 198),
        inversePrimary: Color.fromARGB(255, 141, 191, 141),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 141, 191, 141),
        secondary: Color.fromARGB(255, 166, 221, 166),
        tertiary: Color.fromARGB(255, 218, 255, 218),
        inversePrimary: Color.fromARGB(255, 198, 245, 198),
      ));
}

class DarkGreenTheme {
  int colorThemeId = 7;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 55, 140, 93),
        primary: Color.fromARGB(255, 39, 115, 78),
        secondary: Color.fromARGB(255, 21, 102, 67),
        tertiary: Color.fromARGB(255, 10, 85, 54),
        inversePrimary: Color.fromARGB(255, 2, 50, 31),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 2, 50, 31),
        secondary: Color.fromARGB(255, 14, 70, 44),
        tertiary: Color.fromARGB(255, 39, 115, 78),
        inversePrimary: Color.fromARGB(255, 10, 85, 54),
      ));
}

class YellowTheme {
  int colorThemeId = 8;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 255, 246, 157),
        primary: Color.fromARGB(255, 255, 228, 95),
        secondary: Color.fromARGB(255, 255, 210, 80),
        tertiary: Color.fromARGB(255, 255, 180, 64),
        inversePrimary: Color.fromARGB(255, 155, 140, 34),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 155, 140, 34),
        secondary: Color.fromARGB(255, 255, 180, 64),
        tertiary: Color.fromARGB(255, 255, 228, 95),
        inversePrimary: Color.fromARGB(255, 255, 246, 157),
      ));
}

class OrangeTheme {
  int colorThemeId = 9;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 255, 227, 196),
        primary: Color.fromARGB(255, 255, 199, 165),
        secondary: Color.fromARGB(255, 255, 179, 137),
        tertiary: Color.fromARGB(255, 255, 145, 111),
        inversePrimary: Color.fromARGB(255, 155, 88, 43),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 155, 88, 43),
        secondary: Color.fromARGB(255, 255, 145, 111),
        tertiary: Color.fromARGB(255, 255, 199, 165),
        inversePrimary: Color.fromARGB(255, 255, 227, 196),
      ));
}
