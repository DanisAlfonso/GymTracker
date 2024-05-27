// training_screen.dart
import 'package:flutter/material.dart';
import 'create_routine_screen.dart';
import 'start_routine_screen.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  void _renameRoutine(BuildContext context, Routine routine) {
    final nameController = TextEditingController(text: routine.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Routine'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter new routine name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<WorkoutModel>(context, listen: false).renameRoutine(routine, nameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRoutine(BuildContext context, Routine routine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Routine'),
          content: const Text('Are you sure you want to delete this routine?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WorkoutModel>(context, listen: false).deleteRoutine(routine);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        centerTitle: true,
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          return workoutModel.routines.isNotEmpty
              ? ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: workoutModel.routines.length,
            itemBuilder: (context, index) {
              final routine = workoutModel.routines[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _renameRoutine(context, routine);
                      } else if (value == 'delete') {
                        _deleteRoutine(context, routine);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'rename',
                          child: Text('Rename Routine'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete Routine'),
                        ),
                      ];
                    },
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
            },
          )
              : Center(
            child: Text(
              'No routines created yet.',
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoutineScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create New Routine'),
      ),
    );
  }
}
