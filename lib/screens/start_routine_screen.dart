// start_routine_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'track_progress_screen.dart';

class StartRoutineScreen extends StatelessWidget {
  final Routine routine;

  const StartRoutineScreen({super.key, required this.routine});

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
                children: exerciseWorkouts.map((workout) {
                  return ListTile(
                    title: Text('Set: ${workout.sets} x ${workout.repetitions} reps'),
                    subtitle: Text('Weight: ${workout.weight} kg'),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackProgressScreen(routine: routine),
            ),
          );
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
