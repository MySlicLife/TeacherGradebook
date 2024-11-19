

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/presentation/theme/colors.dart';
import 'package:teacher_gradebook/storage/settings/settings_storage.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final SettingsCubit settingsCubit;

  final List<dynamic> colorThemes = [
    GreyTheme(),
    PinkTheme(),
    RedTheme(),
    PurpleTheme(),
    BlueTheme(),
    GreenTheme(),
    YellowTheme(),
    OrangeTheme(),
  ];

  int selectedThemeIndex = 0; // Default theme index if settings are not loaded yet
  bool _isDarkMode = false;  // Default dark mode state if settings are not loaded yet

  // Constructor
  ThemeCubit({required this.settingsCubit})
      : super(ThemeData.light()) {
    // Listen to SettingsCubit stream and update theme
    settingsCubit.stream.listen((settingsState) {
      _isDarkMode = settingsState.isDarkMode;
      selectedThemeIndex = settingsState.appThemeInt;
      _applyTheme(); // Reapply the selected theme whenever settings change
    });
  }

  // Apply the theme based on _isDarkMode and selectedThemeIndex
  void _applyTheme() {
    final theme = colorThemes[selectedThemeIndex];
    emit(_isDarkMode ? theme.darkMode : theme.lightMode);
  }

  // Ensure that the theme is applied correctly during initialization
  Future<void> initializeTheme() async {
    // Load settings before applying the theme
    await settingsCubit.loadSettings();
    _isDarkMode = settingsCubit.state.isDarkMode;
    selectedThemeIndex = settingsCubit.state.appThemeInt;
    _applyTheme();
  }

  // Method to select a theme
  void selectTheme(int newIndex) {
    selectedThemeIndex = newIndex; // Update the instance variable

    final theme = colorThemes[selectedThemeIndex];
    emit(_isDarkMode ? theme.darkMode : theme.lightMode); // Emit the appropriate theme
  }

  // Method to toggle between dark and light mode
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Toggle the mode

    final theme = colorThemes[selectedThemeIndex];
    emit(_isDarkMode ? theme.darkMode : theme.lightMode); // Emit the appropriate theme

    await settingsCubit.toggleTheme(); // Save the theme setting in the settingsCubit
  }
}
