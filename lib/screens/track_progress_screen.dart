// track_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'add_set_screen.dart';

class TrackProgressScreen extends StatelessWidget {
  final Routine routine;

  const TrackProgressScreen({super.key, required this.routine});

  void _addSet(BuildContext context, Exercise exercise) {
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
        title: Text('Track Progress - ${routine.name}'),
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
                  ...exerciseWorkouts.map((workout) {
                    return ListTile(
                      title: Text('Set: ${workout.sets} x ${workout.repetitions} reps'),
                      subtitle: Text('Weight: ${workout.weight} kg'),
                    );
                  }),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () => _addSet(context, exercise),
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
