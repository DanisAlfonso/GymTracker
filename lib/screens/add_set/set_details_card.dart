import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../app_localizations.dart';

class SetDetailsCard extends StatelessWidget {
  final int setNumber;
  final int repetitions;
  final int weightInt;
  final int weightDecimal;
  final TextStyle selectedTextStyle;
  final TextStyle textStyle;
  final Color iconColor;
  final BorderSide cardBorder;
  final Function(int) onSetNumberChanged;
  final Function(int) onRepetitionsChanged;
  final Function(int) onWeightIntChanged;
  final Function(int) onWeightDecimalChanged;
  final VoidCallback onSubmit;

  const SetDetailsCard({
    super.key,
    required this.setNumber,
    required this.repetitions,
    required this.weightInt,
    required this.weightDecimal,
    required this.selectedTextStyle,
    required this.textStyle,
    required this.iconColor,
    required this.cardBorder,
    required this.onSetNumberChanged,
    required this.onRepetitionsChanged,
    required this.onWeightIntChanged,
    required this.onWeightDecimalChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: cardBorder,
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_list_numbered, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('set_number') ?? 'Set Number',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: NumberPicker(
                minValue: 1,
                maxValue: 10,
                value: setNumber,
                onChanged: onSetNumberChanged,
                selectedTextStyle: selectedTextStyle,
                textStyle: textStyle,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                Icon(Icons.repeat, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('repetitions') ?? 'Repetitions',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: NumberPicker(
                minValue: 1,
                maxValue: 100,
                value: repetitions,
                onChanged: onRepetitionsChanged,
                selectedTextStyle: selectedTextStyle,
                textStyle: textStyle,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                Icon(Icons.fitness_center, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('weight_kg') ?? 'Weight (kg)',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 1000,
                  value: weightInt,
                  onChanged: onWeightIntChanged,
                  selectedTextStyle: selectedTextStyle,
                  textStyle: textStyle,
                ),
                const Text(
                  '.',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 9,
                  value: weightDecimal,
                  onChanged: onWeightDecimalChanged,
                  selectedTextStyle: selectedTextStyle,
                  textStyle: textStyle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  appLocalizations?.translate('add_set') ?? 'Add Set',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
