import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPickerDialog extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;

  const DurationPickerDialog({
    Key? key,
    required this.initialMinutes,
    required this.initialSeconds,
  }) : super(key: key);

  @override
  _DurationPickerDialogState createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialMinutes;
    seconds = widget.initialSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Rest Time',
        style: TextStyle(color: Colors.deepPurpleAccent),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberPicker(
                minValue: 0,
                maxValue: 59,
                value: minutes,
                onChanged: (value) {
                  setState(() {
                    minutes = value;
                  });
                },
                selectedTextStyle: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 24),
                textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const Text(
                'min',
                style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
              ),
              NumberPicker(
                minValue: 0,
                maxValue: 59,
                value: seconds,
                onChanged: (value) {
                  setState(() {
                    seconds = value;
                  });
                },
                selectedTextStyle: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 24),
                textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const Text(
                'sec',
                style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, Duration(minutes: minutes, seconds: seconds));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
          ),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
