import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import 'edit_workout_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutModel = Provider.of<WorkoutModel>(context);
    final recentWorkouts = workoutModel.workouts.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Welcome to Gym Tracker!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildCurrentWorkoutPlan(context),
            const SizedBox(height: 20),
            _buildProgressOverview(context),
            const SizedBox(height: 20),
            _buildRecentActivities(context, recentWorkouts),
            const SizedBox(height: 20),
            _buildAllActivities(context, workoutModel.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWorkoutPlan(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Workout Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Plan Name: Full Body Workout',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Next Workout: Bench Press, Squats',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to workout details
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 2.5),
                        FlSpot(2, 4),
                        FlSpot(3, 3.5),
                        FlSpot(4, 4.5),
                      ],
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.blue,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, List<Workout> recentWorkouts) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: entry.value.asMap().entries.map((e) {
                  final workout = e.value;
                  return Dismissible(
                    key: Key('${workout.exercise.name}-${workout.date}-${e.key}'), // Unique key for each workout
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text('Are you sure you want to delete this workout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      Provider.of<WorkoutModel>(context, listen: false).deleteWorkout(workout);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout deleted')));
                    },
                    child: ListTile(
                      title: Text('${workout.exercise.name} - ${workout.repetitions} reps'),
                      subtitle: Text('${workout.weight} kg, ${DateFormat('yyyy-MM-dd – kk:mm').format(workout.date)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditWorkoutScreen(workout: workout),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
            if (recentWorkouts.isEmpty)
              const Text(
                'No recent activities',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllActivities(BuildContext context, List<Workout> allWorkouts) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...groupedWorkouts.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: entry.value.asMap().entries.map((e) {
                  final workout = e.value;
                  return Dismissible(
                    key: Key('${workout.exercise.name}-${workout.date}-${e.key}'), // Unique key for each workout
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text('Are you sure you want to delete this workout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      Provider.of<WorkoutModel>(context, listen: false).deleteWorkout(workout);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout deleted')));
                    },
                    child: ListTile(
                      title: Text('${workout.exercise.name} - ${workout.repetitions} reps'),
                      subtitle: Text('${workout.weight} kg, ${DateFormat('yyyy-MM-dd – kk:mm').format(workout.date)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditWorkoutScreen(workout: workout),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
            if (allWorkouts.isEmpty)
              const Text(
                'No activities',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
