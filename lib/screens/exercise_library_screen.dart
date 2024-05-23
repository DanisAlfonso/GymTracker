// exercise_library_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  final List<Exercise> selectedExercises;

  ExerciseLibraryScreen({required this.selectedExercises});

  @override
  _ExerciseLibraryScreenState createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
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

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<WorkoutModel>(context).exercises;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Library'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final isSelected = _selectedExercises.contains(exercise);
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text(exercise.description),
            trailing: isSelected
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            onTap: () => _toggleSelection(exercise),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedExercises);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class AddExerciseDialog extends StatefulWidget {
  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final exercise = Exercise(
        name: _nameController.text,
        description: _descriptionController.text,
      );

      Provider.of<WorkoutModel>(context, listen: false).addCustomExercise(exercise);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Exercise'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the exercise name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the exercise description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Add'),
        ),
      ],
    );
  }
}