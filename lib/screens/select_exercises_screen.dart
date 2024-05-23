// select_exercises_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class SelectExercisesScreen extends StatefulWidget {
  const SelectExercisesScreen({super.key});

  @override
  _SelectExercisesScreenState createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  final List<Exercise> _selectedExercises = [];

  void _toggleExercise(Exercise exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _submitSelection() {
    Navigator.pop(context, _selectedExercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercises'),
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          return ListView.builder(
            itemCount: workoutModel.exercises.length,
            itemBuilder: (context, index) {
              final exercise = workoutModel.exercises[index];
              final isSelected = _selectedExercises.contains(exercise);
              return ListTile(
                title: Text(exercise.name),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () => _toggleExercise(exercise),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitSelection,
        child: const Icon(Icons.check),
      ),
    );
  }
}
