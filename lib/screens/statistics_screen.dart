import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'statistics/exercise_performance.dart';
import 'statistics/weekly_progress.dart';
import 'statistics/exercise_frequency.dart';
import 'statistics/monthly_progress.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Exercise? _selectedExercise;

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

            return SingleChildScrollView(
              child: Column(
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
                      color: Theme.of(context).inputDecorationTheme.fillColor,
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
                  if (_selectedExercise != null)
                    ExercisePerformanceSection(selectedExercise: _selectedExercise!),
                  const SizedBox(height: 32),
                  WeeklyProgressSection(),
                  const SizedBox(height: 32),
                  ExerciseFrequencySection(),
                  const SizedBox(height: 32),
                  MonthlyProgressSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
