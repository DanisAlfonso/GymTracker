// lib/screens/duration_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../app_localizations.dart';

class DurationPickerDialog extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;

  const DurationPickerDialog({
    super.key,
    required this.initialMinutes,
    required this.initialSeconds,
  });

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
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final localization = AppLocalizations.of(context);

    return AlertDialog(
      title: Center(
        child: Text(
          localization?.translate('select_rest_time') ?? 'Select Rest Time',
          style: TextStyle(color: textColor),
        ),
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
                selectedTextStyle: TextStyle(color: theme.primaryColor, fontSize: 24),
                textStyle: TextStyle(color: textColor, fontSize: 18),
              ),
              Text(
                localization?.translate('min') ?? 'min',
                style: TextStyle(fontSize: 18, color: textColor),
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
                selectedTextStyle: TextStyle(color: theme.primaryColor, fontSize: 24),
                textStyle: TextStyle(color: textColor, fontSize: 18),
              ),
              Text(
                localization?.translate('sec') ?? 'sec',
                style: TextStyle(fontSize: 18, color: textColor),
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
          child: Text(
            localization?.translate('cancel') ?? 'Cancel',
            style: TextStyle(color: theme.primaryColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, Duration(minutes: minutes, seconds: seconds));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
          ),
          child: Text(
            localization?.translate('ok') ?? 'OK',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
