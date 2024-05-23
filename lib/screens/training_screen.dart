// training_screen.dart
import 'package:flutter/material.dart';
import 'create_routine_screen.dart';
import 'start_routine_screen.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          return ListView.builder(
            itemCount: workoutModel.routines.length,
            itemBuilder: (context, index) {
              final routine = workoutModel.routines[index];
              return ListTile(
                title: Text(routine.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartRoutineScreen(routine: routine),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoutineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
