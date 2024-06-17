import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import 'package:intl/intl.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class TotalSetsPerWeekSection extends StatefulWidget {
  const TotalSetsPerWeekSection({super.key});

  @override
  _TotalSetsPerWeekSectionState createState() => _TotalSetsPerWeekSectionState();
}

class _TotalSetsPerWeekSectionState extends State<TotalSetsPerWeekSection> {
  int touchedIndex = -1;

  // Get the start of the current week (Monday)
  DateTime _startOfWeek(DateTime date) {
    final int daysToSubtract = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }

  // Get the end of the current week (Sunday)
  DateTime _endOfWeek(DateTime date) {
    final int daysToAdd = DateTime.sunday - date.weekday;
    return DateTime(date.year, date.month, date.day).add(Duration(days: daysToAdd));
  }

  Map<String, int> _generateTotalSetsPerWeek(WorkoutModel workoutModel) {
    final Map<String, int> setsPerWeek = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    DateTime today = DateTime.now();
    DateTime startOfWeek = _startOfWeek(today);
    DateTime endOfWeek = _endOfWeek(today);

    for (var workout in workoutModel.workouts) {
      if (workout.date.isAfter(startOfWeek.subtract(Duration(days: 1))) && workout.date.isBefore(endOfWeek.add(Duration(days: 1)))){
        String day = DateFormat.E().format(workout.date);
        setsPerWeek[day] = setsPerWeek[day]! + 1;
      }
    }

    return setsPerWeek;
  }

  List<BarChartGroupData> _generateBarGroups(Map<String, int> setsPerWeek) {
    List<BarChartGroupData> barGroups = [];
    int index = 0;
    setsPerWeek.forEach((day, totalSets) {
      barGroups.add(BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalSets.toDouble(),
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
        final setsPerWeek = _generateTotalSetsPerWeek(workoutModel);
        final totalSetsBars = _generateBarGroups(setsPerWeek);
        final totalSets = setsPerWeek.values.reduce((a, b) => a + b);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations!.translate('total_sets_per_week'),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalSetsBars.length * 50.0, // Adjusted width based on the number of bars
                        child: BarChart(
                          BarChartData(
                            barGroups: totalSetsBars,
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
                                    if (value % 5 == 0) { // Show titles only for grid lines
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
                                    appLocalizations.translate('sets'),
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
                                    '$day\n${rod.toY.toStringAsFixed(0)}',
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
                            maxY: (totalSetsBars.map((group) => group.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b)).reduce((a, b) => a > b ? a : b)) * 1.1, // 10% space above the highest bar
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...setsPerWeek.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        Text(
                          entry.value.toString(),
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Text(
                  '${appLocalizations.translate('total')}: $totalSets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
