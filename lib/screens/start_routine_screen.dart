import 'package:flutter/material.dart';
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
      body: ListView.builder(
        itemCount: routine.exercises.length,
        itemBuilder: (context, index) {
          final exercise = routine.exercises[index];
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text(exercise.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSetScreen(exercise: exercise)),
              );
            },
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle adding the set (this part can be expanded based on how you manage sets)
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
