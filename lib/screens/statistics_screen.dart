import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Exercise? _selectedExercise;

  List<FlSpot> _generatePerformanceSpots(WorkoutModel workoutModel, Exercise exercise) {
    final workouts = workoutModel.workouts.where((workout) => workout.exercise == exercise).toList();
    workouts.sort((a, b) => a.date.compareTo(b.date));
    return workouts
        .asMap()
        .entries
        .map<FlSpot>((entry) => FlSpot(entry.key.toDouble(), entry.value.repetitions * entry.value.weight))
        .toList();
  }

  double _findMinY(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 0;
    }
    return spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
  }

  double _findMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 0;
    }
    return spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<WorkoutModel>(
          builder: (context, workoutModel, child) {
            final exercises = workoutModel.exercises;
            final performanceSpots = _selectedExercise != null ? _generatePerformanceSpots(workoutModel, _selectedExercise!) : <FlSpot>[];
            final minY = _findMinY(performanceSpots);
            final maxY = _findMaxY(performanceSpots);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Exercise',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Exercise>(
                      hint: const Text('Select Exercise'),
                      value: _selectedExercise,
                      onChanged: (Exercise? newValue) {
                        setState(() {
                          _selectedExercise = newValue;
                        });
                      },
                      items: exercises.map((Exercise exercise) {
                        return DropdownMenuItem<Exercise>(
                          value: exercise,
                          child: Text(exercise.name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_selectedExercise != null) ...[
                  Text(
                    '${_selectedExercise!.name} Performance Progress',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: const Color(0xffe7e8ec),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: const Color(0xffe7e8ec),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: (maxY - minY) / 5,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(value.toStringAsFixed(0), style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                );
                              },
                            ),
                            axisNameWidget: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Performance (Reps x Weight)',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(value.toStringAsFixed(0), style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                );
                              },
                            ),
                            axisNameWidget: const Text(
                              'Set Number',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: const Color(0xffe7e8ec)),
                        ),
                        minX: 0,
                        maxX: performanceSpots.isNotEmpty ? performanceSpots.length - 1.toDouble() : 0,
                        minY: minY - (minY * 0.1), // Add some padding to the bottom
                        maxY: maxY + (maxY * 0.1), // Add some padding to the top
                        lineBarsData: [
                          LineChartBarData(
                            spots: performanceSpots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
