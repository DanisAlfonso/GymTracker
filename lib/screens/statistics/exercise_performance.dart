// exercise_performance.dart
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

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final workouts = workoutModel.workouts.where((workout) => workout.exercise.name == selectedExercise.name).toList();
        final performanceSpots = _generatePerformanceSpots(workoutModel, selectedExercise);

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
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          appLocalizations.translate('weight_volume'),
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
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
                        interval: performanceSpots.isNotEmpty
                            ? (performanceSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) / 10)
                            : 100,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          appLocalizations.translate('date'),
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatDate(value, workouts),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                            overflow: TextOverflow.visible,
                          );
                        },
                        interval: 1,
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
                  maxY: performanceSpots.isNotEmpty ? performanceSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0,
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
