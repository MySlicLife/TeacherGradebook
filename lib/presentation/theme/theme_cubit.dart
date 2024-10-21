

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/presentation/theme/colors.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final List<dynamic> colorThemes = [
    GreyTheme(),
    PinkTheme(),
    RedTheme(),
    PurpleTheme(),
    LightBlueTheme(),
    BlueTheme(),
    GreenTheme(),
    DarkGreenTheme(),
    YellowTheme(),
    OrangeTheme(),
  ];

  int selectedThemeIndex; // Keep track of the selected theme index
  bool _isDarkMode; // Current mode (dark/light)

  // Constructor
  ThemeCubit({bool isDarkMode = false, this.selectedThemeIndex = 0})
      : _isDarkMode = isDarkMode,
        super(_getInitialTheme(selectedThemeIndex, isDarkMode));

  get isDarkMode => _isDarkMode;

  // Static method to get the initial theme
  static ThemeData _getInitialTheme(int index, bool isDarkMode) {
    final List<dynamic> themes = [
      GreyTheme(),
      RedTheme(),
      PurpleTheme(),
      BlueTheme(),
      GreenTheme(),
      YellowTheme(),
      OrangeTheme(),
    ];

    final theme = (index < 0 || index >= themes.length) ? themes[0] : themes[index];
    return isDarkMode ? theme.darkMode : theme.lightMode;
  }

  // Method to select a theme
  void selectTheme(int newIndex) {
    selectedThemeIndex = newIndex; // Update the instance variable

    final theme = colorThemes[selectedThemeIndex];
    emit(_isDarkMode ? theme.darkMode : theme.lightMode); // Emit the appropriate theme

  }

  // Method to toggle between dark and light mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Toggle the mode

    final theme = colorThemes[selectedThemeIndex];
    emit(_isDarkMode ? theme.darkMode : theme.lightMode); // Emit the appropriate theme
  }
}
