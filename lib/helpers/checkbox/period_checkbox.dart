import 'package:flutter/material.dart';

class ClassPeriodSelector extends StatefulWidget {
  final Function(String) onClassPeriodSelected;

  const ClassPeriodSelector({super.key, required this.onClassPeriodSelected});

  @override
  ClassPeriodSelectorState createState() => ClassPeriodSelectorState();
}

class ClassPeriodSelectorState extends State<ClassPeriodSelector> {
  final TextEditingController _controller = TextEditingController();
  bool _isASelected = false;
  bool _isBSelected = false;

  String get selectedClass {
    String period = _controller.text;
    String suffix = '';

    if (_isASelected) {
      suffix = 'A';
    } else if (_isBSelected) {
      suffix = 'B';
    }

    return '$period$suffix';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Return the class period value whenever it changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onClassPeriodSelected(selectedClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Period',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Call onChanged to update the class period whenever the text changes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onClassPeriodSelected(selectedClass);
                });
              },
            ),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isASelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isASelected = value ?? false;
                        if (_isASelected) _isBSelected = false; // Only one can be selected
                      });
                      // Update the selected class after state has changed
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onClassPeriodSelected(selectedClass);
                      });
                    },
                  ),
                  Text('A'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isBSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        _isBSelected = value ?? false;
                        if (_isBSelected) _isASelected = false; // Only one can be selected
                      });
                      // Update the selected class after state has changed
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onClassPeriodSelected(selectedClass);
                      });
                    },
                  ),
                  Text('B'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
