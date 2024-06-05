import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class WeeklyProgressSection extends StatefulWidget {
  const WeeklyProgressSection({super.key});

  @override
  _WeeklyProgressSectionState createState() => _WeeklyProgressSectionState();
}

class _WeeklyProgressSectionState extends State<WeeklyProgressSection> {
  int touchedIndex = -1;

  List<BarChartGroupData> _generateWeeklyProgress(WorkoutModel workoutModel) {
    final Map<String, double> weeklyProgress = {
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
      'Sun': 0.0,
    };

    for (var workout in workoutModel.workouts) {
      String day = DateFormat.E().format(workout.date);
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
            color: Colors.primaries[index % Colors.primaries.length], // Different color for each day
            borderRadius: BorderRadius.circular(4),
            width: 20, // Reduced width of each bar
          ),
        ],
        showingTooltipIndicators: touchedIndex == index ? [0] : [],
      ));
      index++;
    });

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black54;

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
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: weeklyProgressBars.length * 50.0, // Adjusted width based on the number of bars
                  child: BarChart(
                    BarChartData(
                      barGroups: weeklyProgressBars,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32, // Increased reserved size for bottom titles
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0), // Increased top padding
                                child: Text(days[value.toInt()], style: TextStyle(color: textColor)),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // Hide top titles
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48, // Increased reserved size for left titles
                            getTitlesWidget: (value, meta) {
                              if (value % 5000 == 0) { // Show titles only for grid lines
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0), // Adjusted right padding
                                  child: Text(
                                    value.toStringAsFixed(0),
                                    style: TextStyle(color: textColor, fontSize: 12),
                                    overflow: TextOverflow.visible,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              appLocalizations.translate('volume'),
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][group.x.toInt()];
                            return BarTooltipItem(
                              '$day\n${rod.toY.toStringAsFixed(1)}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                        ),
                        touchCallback: (FlTouchEvent event, barTouchResponse) {
                          setState(() {
                            if (barTouchResponse != null && barTouchResponse.spot != null) {
                              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                            } else {
                              touchedIndex = -1;
                            }
                          });
                        },
                        handleBuiltInTouches: true,
                      ),
                      alignment: BarChartAlignment.spaceEvenly, // Ensure even spacing
                      maxY: (weeklyProgressBars.map((group) => group.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b)).reduce((a, b) => a > b ? a : b)) * 1.1, // 10% space above the highest bar
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
