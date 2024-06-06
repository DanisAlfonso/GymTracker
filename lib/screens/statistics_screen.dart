import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'statistics/exercise_performance.dart';
import 'statistics/weekly_progress.dart';
import 'statistics/exercise_frequency.dart';
import 'statistics/monthly_progress.dart';
import 'statistics/calculate_one_rep_max.dart'; // Import the new component
import '../app_localizations.dart'; // Import the AppLocalizations

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Exercise? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('statistics')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<WorkoutModel>(
          builder: (context, workoutModel, child) {
            if (workoutModel == null) {
              return Center(child: CircularProgressIndicator());
            }

            final exercises = workoutModel.exercises;

            // Sort exercises alphabetically
            exercises.sort((a, b) => a.name.compareTo(b.name));

            return ListView(
              children: [
                Text(
                  appLocalizations.translate('select_exercise'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      isDense: true,
                      hint: Text(appLocalizations.translate('select_exercise')),
                      value: _selectedExercise,
                      onChanged: (Exercise? newValue) {
                        setState(() {
                          _selectedExercise = newValue;
                        });
                      },
                      items: exercises.map((Exercise exercise) {
                        return DropdownMenuItem<Exercise>(
                          value: exercise,
                          child: Text(
                            exercise.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_selectedExercise != null)
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ExercisePerformanceSection(selectedExercise: _selectedExercise!),
                    ),
                  ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: WeeklyProgressSection(),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ExerciseFrequencySection(),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: MonthlyProgressSection(),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CalculateOneRepMax(), // Use the new component
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
