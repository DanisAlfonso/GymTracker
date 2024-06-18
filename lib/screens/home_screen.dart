import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import 'edit_workout_screen.dart';
import '../app_localizations.dart'; // Import the AppLocalizations
import 'recovery_status.dart'; // Import the RecoveryStatus

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final workoutModel = Provider.of<WorkoutModel>(context);
    final recentWorkouts = workoutModel.workouts.take(5).toList();
    final theme = Theme.of(context);
    final cardBorder = BorderSide(color: theme.dividerColor.withOpacity(0.5));

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
            const RecoveryStatus(), // Add the RecoveryStatus widget
            const SizedBox(height: 20),
            _buildRecentActivities(context, recentWorkouts, cardBorder),
            const SizedBox(height: 20),
            _buildAllActivities(context, workoutModel.workouts, cardBorder),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, List<Workout> recentWorkouts, BorderSide cardBorder) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in recentWorkouts) {
      String categoryKey = "${workout.exercise.localizationKey}_description";
      String category = appLocalizations?.translate(categoryKey) ?? workout.exercise.description;
      if (groupedWorkouts[category] == null) {
        groupedWorkouts[category] = [];
      }
      groupedWorkouts[category]!.add(workout);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: cardBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: iconColor), // Adjusted icon color based on theme
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('recent_activities') ?? 'Recent Activities',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
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

  Widget _buildAllActivities(BuildContext context, List<Workout> allWorkouts, BorderSide cardBorder) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in allWorkouts) {
      String categoryKey = "${workout.exercise.localizationKey}_description";
      String category = appLocalizations?.translate(categoryKey) ?? workout.exercise.description;
      if (groupedWorkouts[category] == null) {
        groupedWorkouts[category] = [];
      }
      groupedWorkouts[category]!.add(workout);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: cardBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: iconColor), // Adjusted icon color based on theme
                const SizedBox(width: 8),
                Text(
                  appLocalizations?.translate('all_activities') ?? 'All Activities',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Generate a unique set number for each workout within the list
    final List<DataRow> rows = [];
    DateTime? currentWorkoutDate;
    int setNumber = 0;

    for (var workout in workouts) {
      if (currentWorkoutDate == null || !isSameDate(currentWorkoutDate, workout.date)) {
        currentWorkoutDate = workout.date;
        setNumber = 1;
      } else {
        setNumber++;
      }

      rows.add(DataRow(cells: [
        DataCell(Text(appLocalizations?.translate("${workout.exercise.localizationKey}_name") ?? workout.exercise.name, style: TextStyle(color: textColor))),
        DataCell(Text('$setNumber', style: TextStyle(color: textColor))),
        DataCell(Text('${workout.repetitions} ${appLocalizations?.translate('reps') ?? 'reps'}', style: TextStyle(color: textColor))),
        DataCell(Text('${workout.weight} kg', style: TextStyle(color: textColor))),
        DataCell(Text(DateFormat('yyyy-MM-dd – kk:mm').format(workout.date), style: TextStyle(color: textColor))),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: isDarkMode ? Colors.white : theme.primaryColor), // Adjusted icon color based on theme
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
              icon: const Icon(Icons.delete, color: Colors.red),
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
      ]));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(appLocalizations?.translate('exercise') ?? 'Exercise', style: TextStyle(color: textColor))),
          DataColumn(label: Text(appLocalizations?.translate('set') ?? 'Set', style: TextStyle(color: textColor))),
          DataColumn(label: Text(appLocalizations?.translate('reps') ?? 'Reps', style: TextStyle(color: textColor))),
          DataColumn(label: Text(appLocalizations?.translate('weight') ?? 'Weight', style: TextStyle(color: textColor))),
          DataColumn(label: Text(appLocalizations?.translate('date') ?? 'Date', style: TextStyle(color: textColor))),
          DataColumn(label: Text(appLocalizations?.translate('actions') ?? 'Actions', style: TextStyle(color: textColor))),
        ],
        rows: rows,
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
