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
SECONDARY
----------------------------
Usage: Secondary actions or elements that need to be visible but are less critical than primary elements.
Example: Use for secondary buttons or less emphasized elements like borders, dividers, or toggle switches.

----------------------------
TERTIARY
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
    Color.fromARGB(255, 189, 189, 189), //Grey
    Color.fromARGB(255, 255, 198, 211), //Pink
    Color.fromARGB(255, 255, 110, 102), //Red
    Color.fromARGB(255, 195, 177, 225), //Purple
    Color.fromARGB(255, 185, 195, 208), //Light Blue
    Color.fromARGB(255, 43, 58, 87), //Blue
    Color.fromARGB(255, 208, 250, 207), //Light green
    Color.fromARGB(255, 21, 102, 67), // Dark Green
    Color.fromARGB(255, 255, 239, 144), //Yellow
    Color.fromARGB(255, 255, 153, 85), //Orange

  ];
}

class GreyTheme {
  int colorThemeId = 0;
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 224, 224, 224),
        primary: Color.fromARGB(255, 204, 204, 204),
        secondary: Color.fromARGB(255, 189, 189, 189),
        tertiary: Color.fromARGB(255, 174, 174, 174),
        inversePrimary: Color.fromARGB(255, 102, 102, 102),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 102, 102, 102),
        secondary: Color.fromARGB(255, 119, 119, 119),
        tertiary: Color.fromARGB(255, 204, 204, 204),
        inversePrimary: Color.fromARGB(255, 174, 174, 174),
      ));
}

class PinkTheme {
  int colorThemeId = 1;

  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 255, 224, 230),
        primary: Color.fromARGB(255, 255, 211, 220),
        secondary: Color.fromARGB(255, 255, 198, 211),
        tertiary: Color.fromARGB(255, 240, 185, 198),
        inversePrimary: Color.fromARGB(255, 204, 132, 142),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 204, 132, 142),
        secondary: Color.fromARGB(255, 219, 155, 166),
        tertiary: Color.fromARGB(255, 255, 211, 220),
        inversePrimary: Color.fromARGB(255, 240, 185, 198),
      ));
}

class RedTheme {
  int colorThemeId = 2;
  //Light Mode
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 255, 171, 163),
        primary: Color.fromARGB(255, 255, 140, 125),
        secondary: Color.fromARGB(255, 255, 110, 102),
        tertiary: Color.fromARGB(255, 240, 85, 77),
        inversePrimary: Color.fromARGB(255, 204, 45, 39),
      ));

// Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 30, 30, 30),
        primary: Color.fromARGB(255, 204, 45, 39),
        secondary: Color.fromARGB(255, 219, 77, 68),
        tertiary: Color.fromARGB(255, 255, 140, 125),
        inversePrimary: Color.fromARGB(255, 240, 85, 77),
      ));
}

class PurpleTheme {
  int colorThemeId = 3;
  //Light Mode
  ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 201, 185, 228),
        primary: Color.fromARGB(255, 195, 177, 225),
        secondary: Color.fromARGB(255, 231, 223, 243),
        tertiary: Color.fromARGB(255, 237, 231, 246),
        inversePrimary: Color.fromARGB(255, 74, 66, 86),
      ));

  //Dark Mode
  ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Color.fromARGB(255, 2, 1, 2),
        primary: Color.fromARGB(255, 74, 66, 86),
        secondary: Color.fromARGB(255, 96, 87, 112),
        tertiary: Color.fromARGB(255, 195, 177, 225),
        inversePrimary: Color.fromARGB(255, 237, 231, 246),
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
  )
);

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
  )
);

// Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 30, 30, 30),
    primary: Color.fromARGB(255, 155, 140, 34),
    secondary: Color.fromARGB(255, 255, 180, 64),
    tertiary: Color.fromARGB(255, 255, 228, 95),
    inversePrimary: Color.fromARGB(255, 255, 246, 157),
  )
);
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
  )
);

// Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 30, 30, 30),
    primary: Color.fromARGB(255, 155, 88, 43),
    secondary: Color.fromARGB(255, 255, 145, 111),
    tertiary: Color.fromARGB(255, 255, 199, 165),
    inversePrimary: Color.fromARGB(255, 255, 227, 196),
  )
);
}
