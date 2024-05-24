// select_exercises_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class SelectExercisesScreen extends StatefulWidget {
  final List<Exercise> selectedExercises;

  const SelectExercisesScreen({super.key, required this.selectedExercises});

  @override
  _SelectExercisesScreenState createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  final List<Exercise> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _selectedExercises.addAll(widget.selectedExercises);
  }

  void _toggleSelection(Exercise exercise) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitSelection,
          ),
        ],
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
                trailing: isSelected ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                onTap: () => _toggleSelection(exercise),
              );
            },
          );
        },
      ),
    );
  }
}
