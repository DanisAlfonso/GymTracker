import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';

class ExerciseFrequencySection extends StatelessWidget {
  const ExerciseFrequencySection({Key? key}) : super(key: key);

  List<PieChartSectionData> _generateMuscleGroupFrequency(WorkoutModel workoutModel) {
    final Map<String, double> muscleGroupFrequency = {};

    for (var workout in workoutModel.workouts) {
      String muscleGroup = workout.exercise.description;
      if (!muscleGroupFrequency.containsKey(muscleGroup)) {
        muscleGroupFrequency[muscleGroup] = 0.0;
      }
      muscleGroupFrequency[muscleGroup] = muscleGroupFrequency[muscleGroup]! + workout.weight * workout.repetitions;
    }

    return muscleGroupFrequency.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '',
        color: Colors.primaries[muscleGroupFrequency.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final muscleGroupFrequency = _generateMuscleGroupFrequency(workoutModel);
        final muscleGroupLabels = workoutModel.exercises.map((exercise) => exercise.description).toSet().toList();

        // Split labels into two columns
        final int half = (muscleGroupLabels.length / 2).ceil();
        final leftColumnLabels = muscleGroupLabels.sublist(0, half);
        final rightColumnLabels = muscleGroupLabels.sublist(half);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Muscle Group Frequency Distribution',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 200, // Adjust width as needed
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: muscleGroupFrequency,
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: leftColumnLabels.map((label) {
                                final colorIndex = muscleGroupLabels.indexOf(label) % Colors.primaries.length;
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
                                      Text(label),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: rightColumnLabels.map((label) {
                                final colorIndex = muscleGroupLabels.indexOf(label) % Colors.primaries.length;
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
                                      Text(label),
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
