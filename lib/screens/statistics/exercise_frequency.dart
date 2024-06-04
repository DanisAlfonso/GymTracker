// lib/screens/statistics/exercise_frequency.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class ExerciseFrequencySection extends StatelessWidget {
  const ExerciseFrequencySection({super.key});

  Map<String, double> _calculateMuscleGroupFrequency(WorkoutModel workoutModel) {
    final Map<String, double> muscleGroupFrequency = {};
    double totalWeight = 0;

    for (var workout in workoutModel.workouts) {
      String muscleGroup = workout.exercise.description;
      if (!muscleGroupFrequency.containsKey(muscleGroup)) {
        muscleGroupFrequency[muscleGroup] = 0.0;
      }
      muscleGroupFrequency[muscleGroup] = muscleGroupFrequency[muscleGroup]! + workout.weight * workout.repetitions;
      totalWeight += workout.weight * workout.repetitions;
    }

    // Calculate percentages
    muscleGroupFrequency.updateAll((key, value) => (value / totalWeight) * 100);

    return muscleGroupFrequency;
  }

  List<PieChartSectionData> _generatePieChartData(Map<String, double> muscleGroupFrequency) {
    return muscleGroupFrequency.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '',
        color: Colors.primaries[muscleGroupFrequency.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 60,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final muscleGroupFrequency = _calculateMuscleGroupFrequency(workoutModel);
        final muscleGroupFrequencyList = muscleGroupFrequency.entries.toList();

        if (muscleGroupFrequency.isEmpty) {
          return Center(
            child: Text(appLocalizations!.translate('no_data')),
          );
        }

        // Generate pie chart data
        final pieChartData = _generatePieChartData(muscleGroupFrequency);

        // Split labels into two columns
        final int half = (muscleGroupFrequencyList.length / 2).ceil();
        final leftColumnLabels = muscleGroupFrequencyList.sublist(0, half);
        final rightColumnLabels = muscleGroupFrequencyList.sublist(half);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations!.translate('muscle_group_frequency_distribution'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 200, // Adjust width as needed
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: pieChartData,
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
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: leftColumnLabels.map((entry) {
                                final colorIndex = muscleGroupFrequencyList.indexOf(entry) % Colors.primaries.length;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: Colors.primaries[colorIndex],
                                      ),
                                      const SizedBox(width: 8),
                                      Text('${entry.key} (${entry.value.toStringAsFixed(1)}%)'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: rightColumnLabels.map((entry) {
                                final colorIndex = muscleGroupFrequencyList.indexOf(entry) % Colors.primaries.length;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: Colors.primaries[colorIndex],
                                      ),
                                      const SizedBox(width: 8),
                                      Text('${entry.key} (${entry.value.toStringAsFixed(1)}%)'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
