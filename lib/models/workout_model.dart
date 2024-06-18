// lib/models/workout_model.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'exercise_data.dart'; // Import the exercise data
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Exercise {
  final String name;
  final String description;
  final String localizationKey;
  final int recoveryTimeInHours;

  Exercise({
    required this.name,
    required this.description,
    required this.localizationKey,
    required this.recoveryTimeInHours,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'localizationKey': localizationKey,
    'recoveryTimeInHours': recoveryTimeInHours,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      localizationKey: json['localizationKey'],
      recoveryTimeInHours: json['recoveryTimeInHours'] ?? 48, // Provide a default value if null
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
  List<Exercise> _exercises = [];

  List<Workout> get workouts => _workouts;
  List<Routine> get routines => _routines;
  List<Exercise> get exercises => _exercises;

  WorkoutModel() {
    _loadDataWithRetry();
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

  void updateWorkout(Workout workout, double newWeight, int newRepetitions, String newNotes) {
    workout.weight = newWeight;
    workout.repetitions = newRepetitions;
    workout.notes = newNotes;
    _saveData();
    notifyListeners();
  }

  void reorderRoutines(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Routine movedRoutine = _routines.removeAt(oldIndex);
    _routines.insert(newIndex, movedRoutine);
    _saveData();
    notifyListeners();
  }

  List<Workout> getWorkoutsForRoutine(Routine routine) {
    return _workouts.where((workout) => routine.exercises.contains(workout.exercise)).toList();
  }

  void saveData() {
    _saveData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final exercisesJson = jsonEncode(_exercises.map((e) => e.toJson()).toList());

    if (user != null) {
      final userDoc = firestore.collection('users').doc(user.uid);

      await userDoc.set({
        'workouts': jsonEncode(_workouts.map((w) => w.toJson()).toList()),
        'routines': jsonEncode(_routines.map((r) => r.toJson()).toList()),
        'exercises': exercisesJson,
      });
    }

    prefs.setString('workouts', jsonEncode(_workouts.map((w) => w.toJson()).toList()));
    prefs.setString('routines', jsonEncode(_routines.map((r) => r.toJson()).toList()));
    prefs.setString('exercises', exercisesJson);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        final userDoc = firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null) {
            final workoutsString = data['workouts'];
            final routinesString = data['routines'];
            final exercisesString = data['exercises'];

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
              _exercises = exercisesJson.map((e) => Exercise.fromJson(e)).toList();
            } else {
              _exercises = defaultExercises;
              await _saveData(); // Save default exercises to Firebase
            }

            _ensureDefaultExercises();
          }
        }
      } else {
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
          _exercises = exercisesJson.map((e) => Exercise.fromJson(e)).toList();
        } else {
          _exercises = defaultExercises;
          await _saveData(); // Save default exercises to SharedPreferences
        }

        _ensureDefaultExercises();
      }

      if (_exercises.isEmpty) {
        _exercises = defaultExercises;
        await _saveData(); // Save default exercises if no exercises are loaded
      }

      notifyListeners();
    } catch (e) {
      _exercises = defaultExercises;
      notifyListeners();
    }
  }

  Future<void> _loadDataWithRetry({int retries = 3, Duration retryDelay = const Duration(seconds: 2)}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        await _loadData();
        return;
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          rethrow;
        }
        await Future.delayed(retryDelay);
      }
    }
  }

  void _ensureDefaultExercises() {
    bool needsUpdate = false;
    final defaultExerciseNames = defaultExercises.map((e) => e.name).toSet();

    for (final defaultExercise in defaultExercises) {
      if (!_exercises.any((e) => e.name == defaultExercise.name)) {
        _exercises.add(defaultExercise);
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      _saveData();
    }
  }

  Duration timeSinceLastWorkout() {
    if (_workouts.isEmpty) {
      return const Duration(days: 0); // No workouts, no rest needed
    }
    final lastWorkoutDate = _workouts.last.date;
    return DateTime.now().difference(lastWorkoutDate);
  }

  // Calculate total volume per muscle group
  Map<String, double> calculateTotalVolumePerMuscleGroup() {
    Map<String, double> muscleGroupVolume = {};

    for (var workout in _workouts) {
      if (!muscleGroupVolume.containsKey(workout.exercise.localizationKey)) {
        muscleGroupVolume[workout.exercise.localizationKey] = 0.0;
      }
      muscleGroupVolume[workout.exercise.localizationKey] =
          (muscleGroupVolume[workout.exercise.localizationKey] ?? 0.0) +
              (workout.weight * workout.repetitions);
    }
    return muscleGroupVolume;
  }

  // Calculate the last training date per muscle group
  Map<String, DateTime> calculateLastTrainingDatePerMuscleGroup() {
    Map<String, DateTime> lastTrainingDate = {};

    for (var workout in _workouts) {
      lastTrainingDate[workout.exercise.localizationKey] = workout.date;
    }
    return lastTrainingDate;
  }

  // Calculate recovery percentage per muscle group
  Map<String, double> calculateRecoveryPercentagePerMuscleGroup() {
    Map<String, double> recoveryPercentage = {};
    Map<String, DateTime> lastTrainingDate = {};

    for (var workout in _workouts) {
      final muscleGroupDescription = workout.exercise.description; // Use description as a common key

      if (!lastTrainingDate.containsKey(muscleGroupDescription) || workout.date.isAfter(lastTrainingDate[muscleGroupDescription]!)) {
        lastTrainingDate[muscleGroupDescription] = workout.date;
      }
    }

    final currentTime = DateTime.now();
    lastTrainingDate.forEach((muscleGroupDescription, lastDate) {
      final exercise = _exercises.firstWhere((e) => e.description == muscleGroupDescription);
      final hoursSinceLastWorkout = currentTime.difference(lastDate).inHours;
      final recoveryTime = exercise.recoveryTimeInHours;
      final recovery = (hoursSinceLastWorkout / recoveryTime) * 100;
      recoveryPercentage[muscleGroupDescription] = recovery.clamp(0, 100);
    });

    return recoveryPercentage;
  }
}
