import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart'; // Import AppLocalizations

class ExerciseLibraryScreen extends StatefulWidget {
  final List<Exercise> selectedExercises;

  const ExerciseLibraryScreen({super.key, required this.selectedExercises});

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
    final appLocalizations = AppLocalizations.of(context);

    // Group exercises by category
    final Map<String, List<Exercise>> groupedExercises = {};
    for (var exercise in exercises) {
      if (groupedExercises[exercise.description] == null) {
        groupedExercises[exercise.description] = [];
      }
      groupedExercises[exercise.description]!.add(exercise);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('exercise_library')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: groupedExercises.entries.map((entry) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                title: Text(
                  appLocalizations.translate(entry.key),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: entry.value.map((exercise) {
                  final isSelected = _selectedExercises.contains(exercise);
                  return ListTile(
                    title: Text(appLocalizations.translate(exercise.localizationKey)),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.check_circle_outline,
                      color: isSelected ? Colors.green : Colors.grey,
                    ),
                    onTap: () => _toggleSelection(exercise),
                  );
                }).toList(),
              ),
            );
          }).toList(),
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

class AddExerciseDialog extends StatefulWidget {
  const AddExerciseDialog({super.key});

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
        localizationKey: '', // Provide an empty localization key for custom exercises
      );

      Provider.of<WorkoutModel>(context, listen: false).addCustomExercise(exercise);
      Navigator.pop(context, exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(appLocalizations!.translate('add_exercise')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: appLocalizations.translate('name')),
              validator: (value) {
                if (value!.isEmpty) {
                  return appLocalizations.translate('please_enter_exercise_name');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: appLocalizations.translate('description')),
              validator: (value) {
                if (value!.isEmpty) {
                  return appLocalizations.translate('please_enter_exercise_description');
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
          child: Text(appLocalizations.translate('cancel')),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(appLocalizations.translate('add')),
        ),
      ],
    );
  }
}
