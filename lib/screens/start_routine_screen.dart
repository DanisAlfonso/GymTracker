// lib/screens/start_routine_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'add_set_screen.dart';
import 'edit_set_screen.dart';
import 'exercise_library_screen.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

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

  void _editSet(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSetScreen(workout: workout),
      ),
    );
  }

  void _addExercises(BuildContext context) async {
    final newExercises = await Navigator.push<List<Exercise>>(
      context,
      MaterialPageRoute(
        builder: (context) => const ExerciseLibraryScreen(selectedExercises: []),
      ),
    );

    if (newExercises != null && newExercises.isNotEmpty) {
      for (var exercise in newExercises) {
        Provider.of<WorkoutModel>(context, listen: false).addExerciseToRoutine(routine, exercise);
      }
    }
  }

  void _removeExercise(BuildContext context, Exercise exercise) {
    Provider.of<WorkoutModel>(context, listen: false).removeExerciseFromRoutine(routine, exercise);
  }

  void _confirmDeleteWorkout(BuildContext context, Workout workout) {
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations?.translate('delete_set') ?? 'Delete Set'),
          content: Text(appLocalizations?.translate('confirm_delete_set') ?? 'Are you sure you want to delete this set?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLocalizations?.translate('cancel') ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WorkoutModel>(context, listen: false).deleteWorkout(workout);
                Navigator.of(context).pop();
              },
              child: Text(appLocalizations?.translate('delete') ?? 'Delete'),
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
        title: Text(routine.name),
        centerTitle: true,
      ),
      body: Consumer<WorkoutModel>(
        builder: (context, workoutModel, child) {
          final workouts = workoutModel.getWorkoutsForRoutine(routine);
          return ReorderableListView(
            padding: const EdgeInsets.all(16.0),
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final Exercise movedExercise = routine.exercises.removeAt(oldIndex);
              routine.exercises.insert(newIndex, movedExercise);
              workoutModel.saveData();
              workoutModel.notifyListeners();
            },
            children: routine.exercises.map((exercise) {
              final exerciseWorkouts = workouts.where((workout) => workout.exercise == exercise).toList();

              // Calculate total sets and weight for the summary
              final totalSets = exerciseWorkouts.length;
              final totalWeight = exerciseWorkouts.fold(0.0, (sum, workout) => sum + workout.weight);

              return Card(
                key: ValueKey(exercise),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).primaryColor,
                      size: 32.0,
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${appLocalizations?.translate('sets') ?? 'Sets'}: $totalSets, ${appLocalizations?.translate('total_weight') ?? 'Total Weight'}: ${totalWeight.toStringAsFixed(1)} kg',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'remove') {
                          _removeExercise(context, exercise);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'remove',
                            child: Text(appLocalizations?.translate('remove_exercise') ?? 'Remove Exercise'),
                          ),
                        ];
                      },
                    ),
                    children: [
                      Column(
                        children: exerciseWorkouts.map((workout) {
                          return ListTile(
                            title: Text(
                              '${appLocalizations?.translate('reps') ?? 'Reps'}: ${workout.repetitions}, ${appLocalizations?.translate('weight') ?? 'Weight'}: ${workout.weight} kg',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editSet(context, workout),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _confirmDeleteWorkout(context, workout);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _startExercise(context, exercise),
                          icon: const Icon(Icons.add),
                          label: Text(appLocalizations?.translate('add_new_set') ?? 'Add New Set'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black.withOpacity(0.25),
                            elevation: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExercises(context),
        icon: const Icon(Icons.add),
        label: Text(appLocalizations?.translate('add_exercise') ?? 'Add Exercise'),
        tooltip: appLocalizations?.translate('add_exercise') ?? 'Add Exercise',
      ),
    );
  }
}
