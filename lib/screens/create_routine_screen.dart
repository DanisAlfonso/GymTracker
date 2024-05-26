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
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 25.0), // Add padding to the top
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 25.0), // Add padding to the top
          child: Text('Create New Routine'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Routine Name',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter routine name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name for the routine';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _selectExercises,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Select Exercises'),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedExercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(_selectedExercises[index].name),
                    ),
                  );
                },
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
                  child: const Text('Create Routine'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
