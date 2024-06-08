import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart';

class RecoveryStatus extends StatelessWidget {
  const RecoveryStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutModel = Provider.of<WorkoutModel>(context);
    final appLocalizations = AppLocalizations.of(context);
    final recoveryPercentages = workoutModel.calculateRecoveryPercentagePerMuscleGroup();

    // Sort recoveryPercentages by value
    final sortedRecoveryPercentages = recoveryPercentages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hotel, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('recovery_status') ?? 'Recovery Status',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...sortedRecoveryPercentages.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations?.translate(entry.key) ?? entry.key,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: entry.value >= 100 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (recoveryPercentages.isEmpty)
              Text(
                appLocalizations?.translate('no_recent_workouts') ?? 'No recent workouts to show recovery status.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
