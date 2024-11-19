import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the settings state
class SettingsState {
  final bool isDarkMode;
  final String teacherName;
  final int appThemeInt;
  final String version;

  SettingsState({
    required this.isDarkMode,
    required this.teacherName,
    required this.appThemeInt,
    required this.version,
  });
}

// Settings Cubit to manage app settings (including theme, teacher name, etc.)
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          isDarkMode: false,
          teacherName: '',
          appThemeInt: 0, // Add default color
          version: '0.0.0', // Set an initial version
        ));

  // Method to toggle the theme (dark mode)
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTheme = state.isDarkMode;
    final newTheme = !currentTheme;

    // Save the new theme preference
    await prefs.setBool('isDarkMode', newTheme);

    // Emit the new state
    emit(SettingsState(
      isDarkMode: newTheme,
      teacherName: state.teacherName,
      appThemeInt: state.appThemeInt,
      version: state.version,
    ));
  }

  // Method to change the teacher's name
  Future<void> updateTeacherName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('teacherName', name);

    emit(SettingsState(
      isDarkMode: state.isDarkMode,
      teacherName: name,
      appThemeInt: state.appThemeInt,
      version: state.version,
    ));
  }

  // Method to change the app color
  Future<void> updateAppColor(int colorInt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appColorInt', colorInt);

    emit(SettingsState(
      isDarkMode: state.isDarkMode,
      teacherName: state.teacherName,
      appThemeInt: colorInt,
      version: state.version,
    ));
  }

  // Method to update the app version
  Future<void> updateAppVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('version', version);

    emit(SettingsState(
      isDarkMode: state.isDarkMode,
      teacherName: state.teacherName,
      appThemeInt: state.appThemeInt,
      version: version,
    ));
  }

  // Load settings from SharedPreferences when the app starts
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final teacherName = prefs.getString('teacherName') ?? '';
    final appThemeInt = prefs.getInt('appColorInt') ?? 0;
    final version = prefs.getString('version') ?? '1.0.0';

    emit(SettingsState(
      isDarkMode: isDarkMode,
      teacherName: teacherName,
      appThemeInt: appThemeInt,
      version: version,
    ));
  }
}
