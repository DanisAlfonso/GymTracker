// start_routine_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class StartRoutineScreen extends StatelessWidget {
  final Routine routine;

  StartRoutineScreen({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          final workouts = workoutModel.getWorkoutsForRoutine(routine);
          return ListView(
            children: routine.exercises.map((exercise) {
              final exerciseWorkouts = workouts.where((workout) => workout.exercise == exercise).toList();
              return ExpansionTile(
                title: Text(exercise.name),
                children: exerciseWorkouts.map((workout) {
                  return ListTile(
                    title: Text('Set: ${workout.sets} x ${workout.repetitions} reps'),
                    subtitle: Text('Weight: ${workout.weight} kg'),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class AddSetScreen extends StatefulWidget {
  final Exercise exercise;

  AddSetScreen({required this.exercise});

  @override
  _AddSetScreenState createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final repetitions = int.parse(_repsController.text);
      final sets = int.parse(_setsController.text);

      final workout = Workout(
        exercise: widget.exercise,
        sets: sets,
        repetitions: repetitions,
        weight: weight,
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
        title: Text('Add Set'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                    return 'Please enter the repetitions';
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
                child: Text('Add Set'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
