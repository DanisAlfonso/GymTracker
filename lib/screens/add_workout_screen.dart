import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  Exercise? _selectedExercise;

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedExercise != null) {
      final workout = Workout(
        exercise: _selectedExercise!,
        sets: int.parse(_setsController.text),
        repetitions: int.parse(_repsController.text),
        weight: double.parse(_weightController.text),
        date: DateTime.now(),
      );

      Provider.of<WorkoutModel>(context, listen: false).addWorkout(workout);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Exercise>(
                value: _selectedExercise,
                hint: Text('Select Exercise'),
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
                    return 'Please select an exercise';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _setsController,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of sets';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repsController,
                decoration: InputDecoration(labelText: 'Repetitions'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of repetitions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
