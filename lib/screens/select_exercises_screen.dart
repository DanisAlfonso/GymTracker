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
  late List<Exercise> _selectedExercises;

  @override
  void initState() {
    super.initState();
    _selectedExercises = List.from(widget.selectedExercises);
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

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<WorkoutModel>(context).exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            final isSelected = _selectedExercises.contains(exercise);
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  exercise.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                trailing: Icon(
                  isSelected ? Icons.check_circle : Icons.check_circle_outline,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                onTap: () => _toggleSelection(exercise),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedExercises);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
