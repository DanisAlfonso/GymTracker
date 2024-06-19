// lib/widgets/add_set/current_performance_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/workout_model.dart';
import '../../app_localizations.dart';

class CurrentPerformanceCard extends StatelessWidget {
  final List<Workout> currentWorkouts;
  final Color iconColor;
  final BorderSide cardBorder;

  const CurrentPerformanceCard({
    super.key,
    required this.currentWorkouts,
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
              appLocalizations?.translate('current_performance') ?? 'Current Performance',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (currentWorkouts.isNotEmpty) ...[
              for (int i = 0; i < currentWorkouts.length; i++) ...[
                Row(
                  children: [
                    Icon(Icons.format_list_numbered, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${appLocalizations?.translate('set')} ${i + 1}: ${currentWorkouts[i].repetitions} reps, ${currentWorkouts[i].weight} kg',
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
                        DateFormat.yMMMd().add_Hm().format(currentWorkouts[i].date),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ] else ...[
              Text(
                appLocalizations?.translate('no_workouts_today') ?? 'No workouts today',
                style: const TextStyle(fontSize: 16.0),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
