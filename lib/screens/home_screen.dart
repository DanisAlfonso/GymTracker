// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import 'edit_workout_screen.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final workoutModel = Provider.of<WorkoutModel>(context);
    final recentWorkouts = workoutModel.workouts.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.translate('home') ?? 'Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              appLocalizations?.translate('welcome_message') ?? 'Welcome!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildRecentActivities(context, recentWorkouts),
            const SizedBox(height: 20),
            _buildAllActivities(context, workoutModel.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, List<Workout> recentWorkouts) {
    final appLocalizations = AppLocalizations.of(context);
    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in recentWorkouts) {
      String category = workout.exercise.description;
      if (groupedWorkouts[category] == null) {
        groupedWorkouts[category] = [];
      }
      groupedWorkouts[category]!.add(workout);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('recent_activities') ?? 'Recent Activities',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [_buildWorkoutDataTable(context, entry.value)],
              );
            }),
            if (recentWorkouts.isEmpty)
              Text(
                appLocalizations?.translate('no_recent_activities') ?? 'No recent activities',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllActivities(BuildContext context, List<Workout> allWorkouts) {
    final appLocalizations = AppLocalizations.of(context);
    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in allWorkouts) {
      String category = workout.exercise.description;
      if (groupedWorkouts[category] == null) {
        groupedWorkouts[category] = [];
      }
      groupedWorkouts[category]!.add(workout);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('all_activities') ?? 'All Activities',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [_buildWorkoutDataTable(context, entry.value)],
              );
            }),
            if (allWorkouts.isEmpty)
              Text(
                appLocalizations?.translate('no_activities') ?? 'No activities',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDataTable(BuildContext context, List<Workout> workouts) {
    final appLocalizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(appLocalizations?.translate('exercise') ?? 'Exercise')),
          DataColumn(label: Text(appLocalizations?.translate('reps') ?? 'Reps')),
          DataColumn(label: Text(appLocalizations?.translate('weight') ?? 'Weight')),
          DataColumn(label: Text(appLocalizations?.translate('date') ?? 'Date')),
          DataColumn(label: Text(appLocalizations?.translate('actions') ?? 'Actions')),
        ],
        rows: workouts.map((workout) {
          return DataRow(cells: [
            DataCell(Text(workout.exercise.name)),
            DataCell(Text('${workout.repetitions} ${appLocalizations?.translate('reps') ?? 'reps'}')),
            DataCell(Text('${workout.weight} kg')),
            DataCell(Text(DateFormat('yyyy-MM-dd – kk:mm').format(workout.date))),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditWorkoutScreen(workout: workout),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(appLocalizations?.translate('confirm') ?? 'Confirm'),
                          content: Text(appLocalizations?.translate('confirm_delete') ?? 'Are you sure you want to delete this workout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(appLocalizations?.translate('cancel') ?? 'Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(appLocalizations?.translate('delete') ?? 'Delete'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm) {
                      Provider.of<WorkoutModel>(context, listen: false).deleteWorkout(workout);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLocalizations?.translate('workout_deleted') ?? 'Workout deleted')));
                    }
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }
}
