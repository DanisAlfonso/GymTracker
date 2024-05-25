import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
    );
  }
}

class Routine {
  String name;
  final List<Exercise> exercises;

  Routine({required this.name, required this.exercises});

  Map<String, dynamic> toJson() => {
    'name': name,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      name: json['name'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
    );
  }
}

class Workout {
  final Exercise exercise;
  int repetitions;
  double weight;
  Duration restTime;
  String? notes;
  final DateTime date;

  Workout({
    required this.exercise,
    required this.repetitions,
    required this.weight,
    required this.restTime,
    this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'exercise': exercise.toJson(),
    'repetitions': repetitions,
    'weight': weight,
    'restTime': restTime.inSeconds,
    'notes': notes,
    'date': date.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      exercise: Exercise.fromJson(json['exercise']),
      repetitions: json['repetitions'],
      weight: json['weight'],
      restTime: Duration(seconds: json['restTime']),
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
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

  WorkoutModel() {
    _loadData();
  }

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    _saveData();
    notifyListeners();
  }

  void addRoutine(Routine routine) {
    _routines.add(routine);
    _saveData();
    notifyListeners();
  }

  void renameRoutine(Routine routine, String newName) {
    routine.name = newName;
    _saveData();
    notifyListeners();
  }

  void deleteRoutine(Routine routine) {
    _routines.remove(routine);
    _workouts.removeWhere((workout) => routine.exercises.contains(workout.exercise));
    _saveData();
    notifyListeners();
  }

  void addCustomExercise(Exercise exercise) {
    _exercises.add(exercise);
    _saveData();
    notifyListeners();
  }

  void addExerciseToRoutine(Routine routine, Exercise exercise) {
    routine.exercises.add(exercise);
    _saveData();
    notifyListeners();
  }

  void removeExerciseFromRoutine(Routine routine, Exercise exercise) {
    routine.exercises.remove(exercise);
    _workouts.removeWhere((workout) => workout.exercise == exercise);
    _saveData();
    notifyListeners();
  }

  void deleteWorkout(Workout workout) {
    _workouts.remove(workout);
    _saveData();
    notifyListeners();
  }

  void updateWorkout(Workout workout, double newWeight, int newRepetitions) {
    workout.weight = newWeight;
    workout.repetitions = newRepetitions;
    _saveData();
    notifyListeners();
  }

  List<Workout> getWorkoutsForRoutine(Routine routine) {
    return _workouts.where((workout) => routine.exercises.contains(workout.exercise)).toList();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('workouts', jsonEncode(_workouts.map((w) => w.toJson()).toList()));
    prefs.setString('routines', jsonEncode(_routines.map((r) => r.toJson()).toList()));
    prefs.setString('exercises', jsonEncode(_exercises.map((e) => e.toJson()).toList()));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final workoutsString = prefs.getString('workouts');
    final routinesString = prefs.getString('routines');
    final exercisesString = prefs.getString('exercises');

    if (workoutsString != null) {
      final workoutsJson = jsonDecode(workoutsString) as List;
      _workouts.addAll(workoutsJson.map((w) => Workout.fromJson(w)).toList());
    }

    if (routinesString != null) {
      final routinesJson = jsonDecode(routinesString) as List;
      _routines.addAll(routinesJson.map((r) => Routine.fromJson(r)).toList());
    }

    if (exercisesString != null) {
      final exercisesJson = jsonDecode(exercisesString) as List;
      _exercises.clear();
      _exercises.addAll(exercisesJson.map((e) => Exercise.fromJson(e)).toList());
    }

    notifyListeners();
  }
}
