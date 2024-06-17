import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart';

class RestTimeAndNotesCard extends StatelessWidget {
  final Duration restTime;
  final DateTime selectedDate;
  final TextEditingController notesController;
  final VoidCallback onPickRestTime;
  final VoidCallback onPickDate;
  final Color iconColor;
  final BorderSide cardBorder;

  const RestTimeAndNotesCard({
    super.key,
    required this.restTime,
    required this.selectedDate,
    required this.notesController,
    required this.onPickRestTime,
    required this.onPickDate,
    required this.iconColor,
    required this.cardBorder,
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
            Text(
              appLocalizations?.translate('rest_time') ?? 'Rest Time',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: onPickRestTime,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  '${appLocalizations?.translate('pick_rest_time') ?? 'Pick Rest Time'} (${restTime.inMinutes} min ${restTime.inSeconds % 60} sec)',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Text(
              appLocalizations?.translate('training_day') ?? 'Training Day',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: onPickDate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  DateFormat.yMd().format(selectedDate),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Text(
              appLocalizations?.translate('notes') ?? 'Notes',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: appLocalizations?.translate('enter_notes') ?? 'Enter notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
