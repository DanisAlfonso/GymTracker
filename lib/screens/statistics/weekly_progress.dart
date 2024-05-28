// weekly_progress.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';

class WeeklyProgressSection extends StatelessWidget {
  const WeeklyProgressSection({Key? key}) : super(key: key);

  List<BarChartGroupData> _generateWeeklyProgress(WorkoutModel workoutModel) {
    final Map<String, double> weeklyProgress = {};

    for (var workout in workoutModel.workouts) {
      String day = DateFormat.E().format(workout.date);
      if (!weeklyProgress.containsKey(day)) {
        weeklyProgress[day] = 0.0;
      }
      weeklyProgress[day] = weeklyProgress[day]! + workout.weight * workout.repetitions;
    }

    List<BarChartGroupData> barGroups = [];
    int index = 0;
    weeklyProgress.forEach((day, totalWeight) {
      barGroups.add(BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalWeight,
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      ));
      index++;
    });

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final weeklyProgressBars = _generateWeeklyProgress(workoutModel);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: weeklyProgressBars,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                            overflow: TextOverflow.visible,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
