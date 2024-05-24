// workout_model.dart
import 'package:flutter/foundation.dart';

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});
}

class Routine {
  String name;
  final List<Exercise> exercises;

  Routine({required this.name, required this.exercises});
}

class Workout {
  final Exercise exercise;
  int sets;
  int repetitions;
  double weight;
  final DateTime date;

  Workout({
    required this.exercise,
    required this.sets,
    required this.repetitions,
    required this.weight,
    required this.date,
  });
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

  void addRoutine(Routine routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void renameRoutine(Routine routine, String newName) {
    routine.name = newName;
    notifyListeners();
  }

  void deleteRoutine(Routine routine) {
    _routines.remove(routine);
    _workouts.removeWhere((workout) => routine.exercises.contains(workout.exercise));
    notifyListeners();
  }

  void addCustomExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void addExerciseToRoutine(Routine routine, Exercise exercise) {
    routine.exercises.add(exercise);
    notifyListeners();
  }

  void removeExerciseFromRoutine(Routine routine, Exercise exercise) {
    routine.exercises.remove(exercise);
    _workouts.removeWhere((workout) => workout.exercise == exercise);
    notifyListeners();
  }

  void deleteWorkout(Workout workout) {
    _workouts.remove(workout);
    notifyListeners();
  }

  void updateWorkout(Workout workout, double newWeight, int newRepetitions) {
    workout.weight = newWeight;
    workout.repetitions = newRepetitions;
    notifyListeners();
  }

  List<Workout> getWorkoutsForRoutine(Routine routine) {
    return _workouts.where((workout) => routine.exercises.contains(workout.exercise)).toList();
  }
}
