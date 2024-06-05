import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'statistics/exercise_performance.dart';
import 'statistics/weekly_progress.dart';
import 'statistics/exercise_frequency.dart';
import 'statistics/monthly_progress.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Exercise? _selectedExercise;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  double? _oneRepMax;
  Map<String, double>? _percentages;
  Map<String, int>? _reps;

  void _calculateOneRepMax() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final int reps = int.tryParse(_repsController.text) ?? 0;
    if (weight > 0 && reps > 0) {
      setState(() {
        _oneRepMax = weight * (1 + reps / 30.0);
        _percentages = {
          '100%': _oneRepMax!,
          '95%': _oneRepMax! * 0.95,
          '90%': _oneRepMax! * 0.90,
          '85%': _oneRepMax! * 0.85,
          '80%': _oneRepMax! * 0.80,
          '75%': _oneRepMax! * 0.75,
          '70%': _oneRepMax! * 0.70,
          '65%': _oneRepMax! * 0.65,
          '60%': _oneRepMax! * 0.60,
          '55%': _oneRepMax! * 0.55,
          '50%': _oneRepMax! * 0.50,
        };
        _reps = {
          '100%': 1,
          '95%': (30 * (1 / 0.95 - 1)).round(),
          '90%': (30 * (1 / 0.90 - 1)).round(),
          '85%': (30 * (1 / 0.85 - 1)).round(),
          '80%': (30 * (1 / 0.80 - 1)).round(),
          '75%': (30 * (1 / 0.75 - 1)).round(),
          '70%': (30 * (1 / 0.70 - 1)).round(),
          '65%': (30 * (1 / 0.65 - 1)).round(),
          '60%': (30 * (1 / 0.60 - 1)).round(),
          '55%': (30 * (1 / 0.55 - 1)).round(),
          '50%': (30 * (1 / 0.50 - 1)).round(),
        };
      });
    } else {
      setState(() {
        _oneRepMax = null;
        _percentages = null;
        _reps = null;
      });
    }
  }

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
                Text(
                  appLocalizations.translate('calculate_one_rep_max'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.translate('weight'),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _repsController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.translate('reps'),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _calculateOneRepMax,
                          child: Text(appLocalizations.translate('calculate')),
                        ),
                        if (_oneRepMax != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${appLocalizations.translate('one_rep_max')}: ${_oneRepMax!.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                ..._percentages!.entries.map((entry) {
                                  final reps = _reps![entry.key] ?? 0;
                                  return Text(
                                    '${entry.key}: ${entry.value.toStringAsFixed(2)} (${reps} reps)',
                                    style: const TextStyle(fontSize: 16),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                      ],
                    ),
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
