// workout_model.dart
import 'package:flutter/foundation.dart';

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});
}

class Routine {
  final String name;
  final List<Exercise> exercises;

  Routine({required this.name, required this.exercises});
}

class Workout {
  final Exercise exercise;
  int sets;  // Change to mutable
  int repetitions;  // Change to mutable
  double weight;  // Change to mutable
  final DateTime date;

  Workout({
    required this.exercise,
    required this.sets,
    required this.repetitions,
    required this.weight,
    required this.date,
  });

  void updateWeight(double newWeight) {
    weight = newWeight;
  }

  void updateRepetitions(int newRepetitions) {
    repetitions = newRepetitions;
  }
}

class WorkoutModel extends ChangeNotifier {
  final List<Workout> _workouts = [];
  final List<Routine> _routines = [];
  final List<Exercise> _exercises = [
    Exercise(name: 'Bench Press', description: 'Chest exercise'),
    Exercise(name: 'Squat', description: 'Leg exercise'),
    // Add more predefined exercises here
  ];

  List<Workout> get workouts => _workouts;
  List<Routine> get routines => _routines;
  List<Exercise> get exercises => _exercises;

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  void updateWorkout(Workout workout, double newWeight, int newRepetitions) {
    workout.updateWeight(newWeight);
    workout.updateRepetitions(newRepetitions);
    notifyListeners();
  }

  void deleteWorkout(Workout workout) {
    _workouts.remove(workout);
    notifyListeners();
  }

  void addRoutine(Routine routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void addCustomExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  List<Workout> getWorkoutsForRoutine(Routine routine) {
    return _workouts.where((workout) => routine.exercises.contains(workout.exercise)).toList();
  }
}
