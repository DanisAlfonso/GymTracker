import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class WeeklyProgressSection extends StatelessWidget {
  const WeeklyProgressSection({super.key});

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
            borderRadius: BorderRadius.circular(6),
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
    final appLocalizations = AppLocalizations.of(context);

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final weeklyProgressBars = _generateWeeklyProgress(workoutModel);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations!.translate('weekly_progress_overview'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),  // Increased space between title and chart
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
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[value.toInt()]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(color: Colors.black54, fontSize: 12),
                              overflow: TextOverflow.visible,
                            ),
                          );
                        },
                      ),
                      axisNameWidget: Text(
                        appLocalizations.translate('volume'),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      axisNameSize: 32,
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(color: Colors.black54, fontSize: 12),
                              overflow: TextOverflow.visible,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(color: Colors.white),
                        );
                      },
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                    ),
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
