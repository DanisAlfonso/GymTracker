// track_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class TrackProgressScreen extends StatelessWidget {
  const TrackProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Progress'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<WorkoutModel>(
          builder: (context, workoutModel, child) {
            return ListView.builder(
              itemCount: workoutModel.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutModel.workouts[index];
                return Card(
                  child: ListTile(
                    title: Text(workout.exercise.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Repetitions: ${workout.repetitions}'),
                        Text('Weight: ${workout.weight} kg'),
                        Text('Rest Time: ${workout.restTime.inMinutes} min ${workout.restTime.inSeconds % 60} sec'),
                        if (workout.notes != null) Text('Notes: ${workout.notes}'),
                      ],
                    ),
                    trailing: Text(
                      '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}