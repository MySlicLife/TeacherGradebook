import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:teacher_gradebook/presentation/widgets/buttons/icon_button.dart';
import 'package:teacher_gradebook/presentation/widgets/text_field/text_field.dart';
import 'package:teacher_gradebook/storage/settings/settings_storage.dart';

import '../../theme/theme_cubit.dart'; // Assuming SettingsCubit and other dependencies are in this file

class SettingsDrawer extends StatefulWidget {
  final ThemeData screenTheme;
  final ThemeCubit themeCubit;
  final SettingsCubit settingsCubit;
  final TextEditingController nameController;
  final void Function() onTap;

  const SettingsDrawer({
    super.key,
    required this.screenTheme,
    required this.themeCubit,
    required this.settingsCubit,
    required this.nameController,
    required this.onTap,
  });

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late bool _isSwitched; // Control switch state
  late FocusNode _focusNode; // FocusNode to detect tap outside

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // Initialize FocusNode
    _isSwitched = widget.settingsCubit.state
        .isDarkMode; // Set initial switch state based on SettingsCubit
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of FocusNode when not needed
    super.dispose();
  }

  void _handleTapOutside() {
    // When the user taps outside the TextField, update the teacher name
    if (!_focusNode.hasFocus) {
      widget.settingsCubit.updateTeacherName(widget.nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTapOutside, // Detect tap outside the TextField
      child: Drawer(
        child: Container(

            color: widget.screenTheme.colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // DrawerHeader: flex: 1 (relative to the second column)
                Flexible(
                  flex: 1,
                  child: DrawerHeader(
                    child: Icon(Icons.settings, size: 35, color: widget.screenTheme.colorScheme.tertiary,),
                  ),
                ),

                // Second column: flex: 4 (4x the size of DrawerHeader)
                Flexible(
                  flex: 1, // 4 times the size of the first column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: NeumorphicTextField(
                          hintText: "Teacher's Name",
                          textController: widget.nameController,
                          screenTheme: widget.screenTheme,
                          fontSize: 20,
                          cursorHeight: 15,
                          focusNode: _focusNode, // Attach the FocusNode here
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: NeumorphicIconButton(
                            onPressed: widget.onTap,
                            currentTheme: widget.screenTheme,
                            buttonIcon: Icons.color_lens_outlined,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdvancedSwitch(
                            width: 75,
                            enabled: true, // Make sure the switch is enabled
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            inactiveColor: widget.screenTheme.colorScheme.secondary,
                            inactiveChild: Align(
                              alignment: Alignment.center,child: Image.asset('lib/presentation/icons/lightMode.png'),
                            ),
                            activeColor: widget.screenTheme.colorScheme.secondary,
                            activeChild: Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'lib/presentation/icons/darkMode.png'),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isSwitched = value; // Update local state
                              });
                          
                              // Toggle the theme using the themeCubit
                              widget.themeCubit.toggleTheme();
                              widget.settingsCubit.toggleTheme(); // Persist the theme change in SettingsCubit
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Push the third column to the bottom
                Expanded(
                  flex: 1, // Takes up the remaining space
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            "Written by Aleks Slicner",
                            style: TextStyle(
                              color: widget.screenTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            "Version ${widget.settingsCubit.state.version}",
                            style: TextStyle(
                              color: widget.screenTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
