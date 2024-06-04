// lib/screens/statistics/monthly_progress.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class MonthlyProgressSection extends StatelessWidget {
  const MonthlyProgressSection({super.key});

  List<FlSpot> _generateMonthlyProgress(WorkoutModel workoutModel) {
    final Map<String, double> monthlyProgress = {};

    for (var workout in workoutModel.workouts) {
      String month = DateFormat.MMM().format(workout.date);
      if (!monthlyProgress.containsKey(month)) {
        monthlyProgress[month] = 0.0;
      }
      monthlyProgress[month] = monthlyProgress[month]! + workout.weight * workout.repetitions;
    }

    List<FlSpot> lineSpots = [];
    int index = 0;
    monthlyProgress.forEach((month, totalWeight) {
      lineSpots.add(FlSpot(index.toDouble(), totalWeight));
      index++;
    });

    return lineSpots;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final monthlyProgressSpots = _generateMonthlyProgress(workoutModel);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations!.translate('monthly_progress_overview'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
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
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                            overflow: TextOverflow.visible,
                          );
                        },
                        interval: monthlyProgressSpots.isNotEmpty ? ((monthlyProgressSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b)) / 10) : 100,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          return Text(months[value.toInt() % 12]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xffe7e8ec)),
                  ),
                  minX: 0,
                  maxX: monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.length - 1.toDouble() : 0,
                  minY: monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0,
                  maxY: monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyProgressSpots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.3)),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.x.toStringAsFixed(0)}, ${spot.y.toStringAsFixed(0)}',
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
              ),
            ),
          ],
        );
      },
    );
  }
}
