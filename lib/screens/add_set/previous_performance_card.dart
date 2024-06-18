import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/workout_model.dart';
import '../../app_localizations.dart';

class PreviousPerformanceCard extends StatelessWidget {
  final List<Workout> previousWorkouts;
  final Color iconColor;
  final BorderSide cardBorder;

  const PreviousPerformanceCard({
    super.key,
    required this.previousWorkouts,
    required this.iconColor,
    required this.cardBorder,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

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
              appLocalizations?.translate('previous_performance') ?? 'Previous Performance',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < previousWorkouts.length; i++) ...[
              Row(
                children: [
                  Icon(Icons.format_list_numbered, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${appLocalizations?.translate('set')} ${i + 1}: ${previousWorkouts[i].repetitions} reps, ${previousWorkouts[i].weight} kg',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DateFormat.yMMMd().add_Hm().format(previousWorkouts[i].date),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
