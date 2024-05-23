import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class AddSetScreen extends StatefulWidget {
  final Exercise exercise;

  const AddSetScreen({super.key, required this.exercise});

  @override
  _AddSetScreenState createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final repetitions = int.parse(_repsController.text);

      final workout = Workout(
        exercise: widget.exercise,
        sets: 1, // Default to 1 since we're removing the sets field
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
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Add Set'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Repetitions',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _repsController,
                decoration: InputDecoration(
                  hintText: 'Enter repetitions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the repetitions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Weight (kg)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'Enter weight in kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
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
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                  child: const Text(
                    'Add Set',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
