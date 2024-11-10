import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/helpers/update_checker/update_checker.dart';
import 'package:teacher_gradebook/presentation/new_welcome_page.dart';
import 'package:teacher_gradebook/storage/teacher_repo.dart';

import '../storage/school_year/year_cubit.dart';
import 'theme/theme_cubit.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = true;
  bool _isUpdatePromptVisible = false;

  @override
  void initState() {
    super.initState();
   _checkForUpdates();
    

  }

  Future<void> _checkForUpdates() async {
    bool updateAvailable = await checkForUpdates();
    setState(() {
      _isLoading = false;
      _isUpdatePromptVisible =
          updateAvailable; // Show update prompt if available
    });

    if (!updateAvailable) {
      _navigateToWelcomePage();
    }
  }

  void _navigateToWelcomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => YearCubit(TeacherRepo())),
                  BlocProvider(create: (context) => ThemeCubit())
                ],
                child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: YearLandingPage(
                      teacherName: "Ms. Osburn",
                      mainAppThemeId: 0,
                    )))));
  }

  void _launchUpdate() {
    launchUpdate(); // Implement this function to run the downloaded .exe
    setState(() {
      _isUpdatePromptVisible = false; // Hide prompt after launching the update
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title Text
          Text("Teacher Gradebook", style: TextStyle(fontSize: 100)),

          Center(
            child: _isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : Container(
                    color: Colors
                        .green), // Placeholder for when loading is complete
          ),

          // Update Prompt
          if (_isUpdatePromptVisible)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.yellow,
              child: Column(
                children: [
                  Text(
                      'A new version is available. Would you like to download it now?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isUpdatePromptVisible = false; // Hide prompt
                          });
                          _navigateToWelcomePage(); // Navigate to welcome page if not updating
                        },
                        child: Text('No'),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: _launchUpdate,
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Footer Text
          Center(
            child: FutureBuilder<String>(
              future: getAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text("Written by Aleks Slicner, version ${snapshot.data}");
                }}
            ))
        ],
      ),
    );
  }
}
