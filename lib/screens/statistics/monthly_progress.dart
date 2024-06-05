import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class MonthlyProgressSection extends StatelessWidget {
  const MonthlyProgressSection({super.key});

  List<FlSpot> _generateMonthlyProgress(WorkoutModel workoutModel) {
    final Map<int, double> monthlyProgress = {}; // Change key to int for month index

    for (var workout in workoutModel.workouts) {
      int monthIndex = workout.date.month;
      if (!monthlyProgress.containsKey(monthIndex)) {
        monthlyProgress[monthIndex] = 0.0;
      }
      monthlyProgress[monthIndex] = monthlyProgress[monthIndex]! + workout.weight * workout.repetitions;
    }

    List<FlSpot> lineSpots = [];
    monthlyProgress.forEach((monthIndex, totalWeight) {
      lineSpots.add(FlSpot(monthIndex.toDouble(), totalWeight));
    });

    return lineSpots;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black54;

    return Consumer<WorkoutModel>(
      builder: (context, workoutModel, child) {
        final monthlyProgressSpots = _generateMonthlyProgress(workoutModel);
        final maxY = monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0;
        final interval = (maxY / 10).clamp(1, double.infinity).toDouble(); // Ensure interval is never zero and cast to double

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
                        reservedSize: 60, // Increased reserved size for left titles
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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final monthIndex = value.toInt();
                          if (monthIndex >= 1 && monthIndex <= 12) {
                            final monthLabel = DateFormat.MMM().format(DateTime(0, monthIndex));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthLabel,
                                style: TextStyle(color: textColor, fontSize: 12),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xffe7e8ec)),
                  ),
                  minX: monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.map((e) => e.x).reduce((a, b) => a < b ? a : b) - 0.5 : 0,
                  maxX: monthlyProgressSpots.isNotEmpty ? monthlyProgressSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b) + 0.5 : 0,
                  minY: 0,
                  maxY: maxY * 1.1, // 10% space above the highest point
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
                            '${DateFormat.MMM().format(DateTime(0, spot.x.toInt()))}: ${spot.y.toStringAsFixed(0)}',
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
