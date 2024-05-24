// training_screen.dart
import 'package:flutter/material.dart';
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
        centerTitle: true,
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: workoutModel.routines.isNotEmpty
                ? ListView.builder(
              itemCount: workoutModel.routines.length,
              itemBuilder: (context, index) {
                final routine = workoutModel.routines[index];
                return RoutineCard(routine: routine);
              },
            )
                : Center(
              child: Text(
                'No routines created yet.',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  final Routine routine;

  const RoutineCard({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          routine.name,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${routine.exercises.length} exercises',
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartRoutineScreen(routine: routine),
            ),
          );
        },
      ),
    );
  }
}
