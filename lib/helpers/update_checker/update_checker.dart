import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:package_info_plus/package_info_plus.dart';

class Logger {
  static late File _logFile;

  static Future<void> init() async {
    try {
      // Get the executable's directory
      String executablePath = Platform.executable;
      String logDirectory = path.dirname(executablePath); // Get the directory of the executable

      _logFile = File('$logDirectory/app_log.txt');

      final formattedDate = getCurrentDateTime();

      // Clear the log file on initialization
      await _logFile.writeAsString('Log file initialized.\n',
          mode: FileMode.write); // Overwrite existing log
      await _logFile.writeAsString('$formattedDate \n',
          mode: FileMode.append); //Initialized time
    } catch (e) {
      await Logger.logMessage('Failed to initialize log file: $e');
    }
  }

  static Future<void> logMessage(String message) async {
    await _logFile.writeAsString('$message\n', mode: FileMode.append);
  }
}

//Get current time
String getCurrentDateTime() {
        final now = DateTime.now();
      final formatter = DateFormat('MM/dd/yyyy HH:mm:ss');
      return formatter.format(now);
}
// Function to check for updates
Future<bool> checkForUpdates() async {
  const versionUrl =
      'https://raw.githubusercontent.com/MySlicLife/TeacherGradebook/main/version.json?v=1'; // Ensure this is the correct URL

  try {
    final response = await http.get(Uri.parse(versionUrl));
    await Logger.logMessage(
        'Response status code: ${response.statusCode}'); // Log status code
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latestVersion = data['version'];
      await Logger.logMessage(
          'Latest Version: $latestVersion'); // Log status code
      // Get the current version
      String? currentVersion = await getAppVersion();
      await Logger.logMessage(
          'Current Version: $currentVersion'); // Log status code
      return currentVersion !=
          latestVersion; // Return true if update is available
    }
  } catch (e) {
    await Logger.logMessage('Error checking for updates $e');
  }
  return false; // Assume no update available on error
}

// Function to get the current version
Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version; // Returns the version as a string
}

// Function to download the new version and prompt the user to run it
Future<void> launchUpdate() async {
  const versionUrl =
      'https://raw.githubusercontent.com/MySlicLife/TeacherGradebook/main/version.json?v=1'; // Ensure this is the correct URL

  try {
    final response = await http.get(Uri.parse(versionUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final downloadUrl = data['url'];
      final latestVersion = data['version']; // Get the new version

      // Download the new version
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Teacher_Gradebook.exe';
      final file = File(filePath);

      final downloadResponse = await http.get(Uri.parse(downloadUrl));
      await file.writeAsBytes(downloadResponse.bodyBytes);

      // Log successful update information
      await Logger.logMessage(
          'Update Downloaded: $filePath, Version: $latestVersion');

      // Optionally, launch the new version
      await runUpdater(filePath);
    }
  } catch (e) {
    await Logger.logMessage('Error downloading updates $e');
  }
}

Future<void> runUpdater(String updatePath) async {
  try {
    await Logger.logMessage('Running updater $updatePath');

    // Start the updater process
    final process = await Process.start(updatePath, ['/SILENT'], mode: ProcessStartMode.normal);
    
    // Wait for the updater to complete with a timeout
    final exitCode = await process.exitCode.timeout(Duration(minutes: 5), onTimeout: () {
      process.kill();
      throw Exception('Updater process timed out');
    });

    if (exitCode == 0) {
      await Logger.logMessage('Updater exited with code: $exitCode');

      // Now delete the updater file
      final file = File(updatePath);
      if (await file.exists()) {
        await file.delete();
        await Logger.logMessage('Updater file deleted: $updatePath');
      }

      // Attempt to restart the app
      try {
        await Logger.logMessage('Attempting to restart the app...');
        final executablePath = Platform.resolvedExecutable;
        await Process.start(executablePath, [], mode: ProcessStartMode.normal);
        exit(0); // Terminate the current instance
      } catch (e) {
        await Logger.logMessage('Restart failed: $e');
      }

    } else {
      await Logger.logMessage('Updater failed with exit code: $exitCode');
    }

  } catch (e) {
    await Logger.logMessage('Error running updater: $e');
  }
}
