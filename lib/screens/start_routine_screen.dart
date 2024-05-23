import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'add_set_screen.dart';

class StartRoutineScreen extends StatelessWidget {
  final Routine routine;

  const StartRoutineScreen({super.key, required this.routine});

  void _startExercise(BuildContext context, Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSetScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          final workouts = workoutModel.getWorkoutsForRoutine(routine);
          return ListView(
            children: routine.exercises.map((exercise) {
              final exerciseWorkouts = workouts.where((workout) => workout.exercise == exercise).toList();
              return ExpansionTile(
                title: Text(exercise.name),
                children: [
                  Column(
                    children: exerciseWorkouts.map((workout) {
                      return ListTile(
                        title: Text('Reps: ${workout.repetitions}, Weight: ${workout.weight} kg'),
                      );
                    }).toList(),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () => _startExercise(context, exercise),
                      child: const Text('Add Set'),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
