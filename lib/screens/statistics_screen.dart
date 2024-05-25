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

  List<FlSpot> _generateWeightSpots(WorkoutModel workoutModel, Exercise exercise) {
    final workouts = workoutModel.workouts.where((workout) => workout.exercise == exercise).toList();
    workouts.sort((a, b) => a.date.compareTo(b.date));
    return workouts
        .asMap()
        .entries
        .map<FlSpot>((entry) => FlSpot(entry.key.toDouble(), entry.value.weight))
        .toList();
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
            final weightSpots = _selectedExercise != null ? _generateWeightSpots(workoutModel, _selectedExercise!) : <FlSpot>[];

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
                    '${_selectedExercise!.name} Weight Progress',
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
                              getTitlesWidget: (value, meta) {
                                return Text(value.toString(), style: const TextStyle(color: Colors.black54, fontSize: 12));
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toString(), style: const TextStyle(color: Colors.black54, fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: const Color(0xffe7e8ec)),
                        ),
                        minX: 0,
                        maxX: weightSpots.isNotEmpty ? weightSpots.length - 1.toDouble() : 0,
                        minY: 0,
                        maxY: weightSpots.isNotEmpty ? weightSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0,
                        lineBarsData: [
                          LineChartBarData(
                            spots: weightSpots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 4,
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
