import 'package:flutter/material.dart';
import 'create_routine_screen.dart';
import 'start_routine_screen.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  void _renameRoutine(BuildContext context, Routine routine) {
    final nameController = TextEditingController(text: routine.name);
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations!.translate('rename_routine')),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: appLocalizations.translate('enter_new_routine_name'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(appLocalizations.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<WorkoutModel>(context, listen: false).renameRoutine(routine, nameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(appLocalizations.translate('rename')),
            ),
          ],
        );
      },
    );
  }

  void _deleteRoutine(BuildContext context, Routine routine) {
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations!.translate('delete_routine')),
          content: Text(appLocalizations.translate('confirm_delete_routine')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(appLocalizations.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WorkoutModel>(context, listen: false).deleteRoutine(routine);
                Navigator.pop(context);
              },
              child: Text(appLocalizations.translate('delete')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('training')),
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
                    '${routine.exercises.length} ${appLocalizations.translate('exercises')}',
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
                        PopupMenuItem<String>(
                          value: 'rename',
                          child: Text(appLocalizations.translate('rename_routine')),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(appLocalizations.translate('delete_routine')),
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
              appLocalizations.translate('no_routines_created'),
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
        label: Text(appLocalizations.translate('create_new_routine')),
      ),
    );
  }
}
