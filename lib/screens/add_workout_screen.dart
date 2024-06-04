// lib/screens/add_workout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'duration_picker_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import '../app_localizations.dart'; // Import AppLocalizations

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  int _repetitions = 1;
  Duration _restTime = const Duration(minutes: 3); // Set default rest time to 3 minutes
  Exercise? _selectedExercise;

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedExercise != null) {
      final weight = double.parse(_weightController.text);
      final notes = _notesController.text.isEmpty ? null : _notesController.text;

      final workout = Workout(
        exercise: _selectedExercise!,
        repetitions: _repetitions,
        weight: weight,
        restTime: _restTime,
        notes: notes,
        date: DateTime.now(),
      );

      Provider.of<WorkoutModel>(context, listen: false).addWorkout(workout);

      Navigator.pop(context);
    }
  }

  Future<void> _pickRestTime() async {
    final pickedTime = await showDialog<Duration>(
      context: context,
      builder: (context) => DurationPickerDialog(
        initialMinutes: _restTime.inMinutes,
        initialSeconds: _restTime.inSeconds % 60,
      ),
    );

    if (pickedTime != null) {
      setState(() {
        _restTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('add_workout')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.translate('select_exercise'),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Exercise>(
                  value: _selectedExercise,
                  hint: Text(appLocalizations.translate('select_exercise')),
                  onChanged: (Exercise? newValue) {
                    setState(() {
                      _selectedExercise = newValue;
                    });
                  },
                  items: Provider.of<WorkoutModel>(context)
                      .exercises
                      .map<DropdownMenuItem<Exercise>>((Exercise exercise) {
                    return DropdownMenuItem<Exercise>(
                      value: exercise,
                      child: Text(exercise.name),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return appLocalizations.translate('please_select_exercise');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  appLocalizations.translate('repetitions'),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Center(
                  child: NumberPicker(
                    minValue: 1,
                    maxValue: 100,
                    value: _repetitions,
                    onChanged: (value) {
                      setState(() {
                        _repetitions = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  appLocalizations.translate('weight_kg'),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    hintText: appLocalizations.translate('enter_weight'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return appLocalizations.translate('please_enter_weight');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  appLocalizations.translate('rest_time'),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _pickRestTime,
                  child: Text(
                    '${appLocalizations.translate('pick_rest_time')} (${_restTime.inMinutes} min ${_restTime.inSeconds % 60} sec)',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  appLocalizations.translate('notes'),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: appLocalizations.translate('enter_notes'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      appLocalizations.translate('add_workout'),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
