// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import 'add_workout_screen.dart';
import 'exercise_library_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.library_books),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExerciseLibraryScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          return ListView.builder(
            itemCount: workoutModel.workouts.length,
            itemBuilder: (context, index) {
              final workout = workoutModel.workouts[index];
              return ListTile(
                title: Text(workout.exercise.name),
                subtitle: Text(
                    '${workout.sets} sets x ${workout.repetitions} reps - ${workout.weight} kg'),
                trailing: Text(DateFormat.yMMMd().format(workout.date)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
