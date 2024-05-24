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
  List<Exercise> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _selectedExercises = widget.selectedExercises;
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
    final exercises = Provider.of<WorkoutModel>(context).exercises;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercises'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitSelection,
            tooltip: 'Confirm Selection',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final isSelected = _selectedExercises.contains(exercise);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(
                Icons.fitness_center,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 32.0,
              ),
              title: Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                ),
              ),
              subtitle: Text(
                exercise.description,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                ),
              ),
              trailing: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              onTap: () => _toggleSelection(exercise),
            ),
          );
        },
      ),
    );
  }
}
