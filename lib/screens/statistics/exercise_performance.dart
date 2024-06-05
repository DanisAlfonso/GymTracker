// lib/screens/statistics/exercise_performance.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations
import 'package:intl/intl.dart';

class ExercisePerformanceSection extends StatelessWidget {
  final Exercise selectedExercise;

  const ExercisePerformanceSection({required this.selectedExercise, super.key});

  List<FlSpot> _generatePerformanceSpots(WorkoutModel workoutModel, Exercise exercise) {
    final workouts = workoutModel.workouts.where((workout) => workout.exercise.name == exercise.name).toList();
    workouts.sort((a, b) => a.date.compareTo(b.date));
    return workouts
        .asMap()
        .entries
        .map<FlSpot>((entry) => FlSpot(entry.key.toDouble(), entry.value.repetitions * entry.value.weight))
        .toList();
  }

  String _formatDate(double value, List<Workout> workouts) {
    final DateTime date = workouts[value.toInt()].date;
    return DateFormat('MM/dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black54;

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final workouts = workoutModel.workouts.where((workout) => workout.exercise.name == selectedExercise.name).toList();
        final performanceSpots = _generatePerformanceSpots(workoutModel, selectedExercise);
        final maxY = performanceSpots.isNotEmpty ? performanceSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0;
        final interval = maxY / 10;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${selectedExercise.name} ${appLocalizations!.translate('performance_progress')}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: performanceSpots.isNotEmpty
                  ? LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color(0xffe7e8ec),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Color(0xffe7e8ec),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Increased reserved size for left titles
                        getTitlesWidget: (value, meta) {
                          if (value % interval == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toStringAsFixed(0),
                                style: TextStyle(color: textColor, fontSize: 12),
                                overflow: TextOverflow.visible,
                              ),
                            );
                          }
                          return Container();
                        },
                        interval: interval,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          if (value % 2 == 0) { // Show only every second date to reduce crowding
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _formatDate(value, workouts),
                                style: TextStyle(color: textColor, fontSize: 12),
                                overflow: TextOverflow.visible,
                              ),
                            );
                          }
                          return Container();
                        },
                        interval: 2, // Adjust the interval for dates
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xffe7e8ec)),
                  ),
                  minX: 0,
                  maxX: performanceSpots.isNotEmpty ? performanceSpots.length - 1.toDouble() : 0,
                  minY: performanceSpots.isNotEmpty ? performanceSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0,
                  maxY: maxY * 1.1, // 10% space above the highest point
                  lineBarsData: [
                    LineChartBarData(
                      spots: performanceSpots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final DateTime date = workouts[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${DateFormat('MM/dd/yyyy').format(date)}, ${spot.y.toStringAsFixed(0)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (touchResponse != null && touchResponse.lineBarSpots != null) {
                        final value = touchResponse.lineBarSpots!.first;
                        // Update something based on the touch event if needed
                      }
                    },
                    handleBuiltInTouches: true,
                  ),
                ),
              )
                  : Center(child: Text(appLocalizations.translate('no_data'))),
            ),
          ],
        );
      },
    );
  }
}
