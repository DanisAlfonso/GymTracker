import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'exercise_library_screen.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<Exercise> _selectedExercises = [];

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedExercises.isNotEmpty) {
      final routine = Routine(
        name: _nameController.text,
        exercises: _selectedExercises,
      );

      Provider.of<WorkoutModel>(context, listen: false).addRoutine(routine);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one exercise.'),
        ),
      );
    }
  }

  void _selectExercises() async {
    final selectedExercises = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseLibraryScreen(
          selectedExercises: _selectedExercises,
        ),
      ),
    );

    if (selectedExercises != null && selectedExercises is List<Exercise>) {
      setState(() {
        _selectedExercises = selectedExercises;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Routine Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name for the routine';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectExercises,
              child: const Text('Select Exercises'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedExercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_selectedExercises[index].name),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Routine'),
            ),
          ],
        ),
      ),
    );
  }
}
