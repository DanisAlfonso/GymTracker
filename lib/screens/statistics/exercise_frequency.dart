// exercise_frequency.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';

class ExerciseFrequencySection extends StatelessWidget {
  const ExerciseFrequencySection({Key? key}) : super(key: key);

  List<PieChartSectionData> _generateExerciseFrequency(WorkoutModel workoutModel) {
    final Map<String, double> exerciseFrequency = {};

    for (var workout in workoutModel.workouts) {
      String exerciseName = workout.exercise.name;
      if (!exerciseFrequency.containsKey(exerciseName)) {
        exerciseFrequency[exerciseName] = 0.0;
      }
      exerciseFrequency[exerciseName] = exerciseFrequency[exerciseName]! + workout.weight * workout.repetitions;
    }

    return exerciseFrequency.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: Colors.primaries[exerciseFrequency.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final exerciseFrequency = _generateExerciseFrequency(workoutModel);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise Frequency Distribution',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: exerciseFrequency,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (event.isInterestedForInteractions && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                        final touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        // Handle touch events if needed
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
