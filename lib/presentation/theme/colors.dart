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
    Color(0xFFB3EBF2), //Blue
    Color(0xFF80EF80), //Green
    Color(0xFFFFEF90), //Yellow
    Color(0xFFFF9955), //Orange
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
    primaryColorDark: Color(0xFF212121),
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
    primaryColorDark: Color(0xFF212121),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF212121), //800
      onSurface: Color(0xFF9E9E9E), //100
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
    primaryColorDark: Color(0xFF332a2c),
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
    primaryColorDark: Color(0xFF332a2c),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF332a2c), //800
      onSurface: Color(0xFF806a6e), //100
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
    primaryColorDark: Color(0xFF331614),
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
    primaryColorDark: Color(0xFF331614),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF331614), //800
      onSurface: Color(0xFF803733), //100
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
      primaryColorDark: Color(0xFF27232d),
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
    primaryColorDark: Color(0xFF27232d),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF27232d), //800
      onSurface: Color(0xFFb09fcb), //100
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

class BlueTheme {
  Color seedColor = Color(0xFFB3EBF2); //Blue
  int colorThemeId = 4;
    ThemeData lightMode = ThemeData(
      primaryColor: Color(0xFFB3EBF2),
      primaryColorDark: Color(0xFF364649),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFe8f9fb), //300
      onSurface: Color(0xFF364649), //800
      primary: Color(0xFFd9f5f9), //400
      onPrimary: Color(0xFF242f30), //800
      secondary: Color(0xFFc2eff5), //500 
      onSecondary: Color(0xFF121718), //900
      tertiary: Color(0xFF8fbcc2), //600
      onTertiary: Color(0xFFf0fbfc), //200
      error: error,
      onError: Color(0xFFf7fdfe) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFB3EBF2),
    primaryColorDark: Color(0xFF364649),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF242f30), //800
      onSurface: Color(0xFF5a7679), //100
      primary: Color(0xFF485e61), //700
      onPrimary: Color(0xFFf0fbfc), //100
      secondary: Color(0xFF6b8d91), //600 
      onSecondary: Color(0xFFf0fbfc), //100
      tertiary: Color(0xFF5a7679), //500
      onTertiary: Color(0xFFf0fbfc), //100
      error: error,
      onError: Color(0xFFf7fdfe) //50
  ));
}


class GreenTheme {
  Color seedColor = Color(0xFF80EF80); //Blue
  int colorThemeId = 5;
    ThemeData lightMode = ThemeData(
      primaryColor: Color(0xFF80EF80),
      primaryColorDark: Color(0xFF1a301a),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFe6fce6), //800L
      onSurface: Color(0xFF1a301a), //800D
      primary: Color(0xFFccf9cc), //600L
      onPrimary: Color(0xFF336033), //600D
      secondary: Color(0xFFb3f5b3), //400L
      onSecondary: Color(0xFF0d180d), //900D
      tertiary: Color(0xFF66bf66), //200D
      onTertiary: Color(0xFFc0f7c0), //500L
      error: error,
      onError: Color(0xFFf7fdfe) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFF80EF80),
    primaryColorDark: Color(0xFF1a301a),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF1a301a), //800D
      onSurface: Color(0xFF407840), //800D
      primary: Color(0xFF264826), //700D
      onPrimary: Color(0xFFd9fad9), //700L
      secondary: Color(0xFF336033), //600D
      onSecondary: Color(0xFFccf9cc), //600L
      tertiary: Color(0xFF407840), //500D
      onTertiary: Color(0xFFc0f7c0), //500L
      error: error,
      onError: Color(0xFFf2fdf2) //900L
  ));
}


class YellowTheme {
    Color seedColor = Color(0xFFFFEF90); //Yellow
  int colorThemeId = 6;
    ThemeData lightMode = ThemeData(
      primaryColor: Color(0xFFFFEF90),
      primaryColorDark: Color(0xFF33301d),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFfffce9), //800L
      onSurface: Color(0xFF33301d), //800D
      primary: Color(0xFFfff9d3), //600L
      onPrimary: Color(0xFF66603a), //600D
      secondary: Color(0xFFfff5bc), //400L
      onSecondary: Color(0xFF19180e), //900D
      tertiary: Color(0xFFccbf73), //200D
      onTertiary: Color(0xFFfff7c8), //500L
      error: error,
      onError: Color(0xFFfffdf4) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFFFEF90),
    primaryColorDark: Color(0xFF33301d),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF33301d), //800D
      onSurface: Color(0xFF807848), //500L
      primary: Color(0xFF4c482b), //700D
      onPrimary: Color(0xFFfffade), //700L
      secondary: Color(0xFF66603a), //600D
      onSecondary: Color(0xFFfff9d3), //600L
      tertiary: Color(0xFF807848), //500D
      onTertiary: Color(0xFFfff7c8), //500L
      error: error,
      onError: Color(0xFFfffdf4) //900L
  ));
}

class OrangeTheme {
    Color seedColor = Color(0xFFFF9955); //Orange
    int colorThemeId = 7;
    ThemeData lightMode = ThemeData(
      primaryColor: Color(0xFFFF9955),
      primaryColorDark: Color(0xFF331f11),
    colorScheme: ColorScheme.light(
      surface: Color(0xFFffebdd), //800L
      onSurface: Color(0xFF331f11), //800D
      primary: Color(0xFFffd6bb), //600L
      onPrimary: Color(0xFF663d22), //600D
      secondary: Color(0xFFffc299), //400L
      onSecondary: Color(0xFF190f08), //900D
      tertiary: Color(0xFFcc7a44), //200D
      onTertiary: Color(0xFFffccaa), //500L
      error: error,
      onError: Color(0xFFfff5ee) //50
  ));

  ThemeData darkMode = ThemeData(
    primaryColor: Color(0xFFFF9955),
    primaryColorDark: Color(0xFF331f11),
    colorScheme: ColorScheme.dark(
      surface: Color(0xFF331f11), //800D
      onSurface: Color(0xFFffccaa), //500L
      primary: Color(0xFF4c2e19), //700D
      onPrimary: Color(0xFFffe0cc), //700L
      secondary: Color(0xFF663d22), //600D
      onSecondary: Color(0xFFffd6bb), //600L
      tertiary: Color(0xFF804d2b), //500D
      onTertiary: Color(0xFFffccaa), //500L
      error: error,
      onError: Color(0xFFfff5ee) //900L
  ));
}
