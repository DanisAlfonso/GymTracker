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
  List<Exercise> _exercises = [];

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
      _exercises = exercisesJson.map((e) => Exercise.fromJson(e)).toList();
    } else {
      _exercises = [
        // Abdominals
        Exercise(name: 'Cable Crunch', description: 'Abdominals'),
        Exercise(name: 'Decline Crunch', description: 'Abdominals'),
        Exercise(name: 'Hanging Knee Raise', description: 'Abdominals'),
        Exercise(name: 'Hanging Leg Raise', description: 'Abdominals'),
        // Adductors
        Exercise(name: 'Hip Adduction (Machine)', description: 'Adductors'),
        // Biceps
        Exercise(name: 'Concentration Curl', description: 'Biceps'),
        Exercise(name: 'Bicep Curl (Barbell)', description: 'Biceps'),
        Exercise(name: 'Bicep Curl (Cable)', description: 'Biceps'),
        Exercise(name: 'Seated Incline Curl', description: 'Biceps'),
        Exercise(name: 'EZ Bar Curl', description: 'Biceps'),
        Exercise(name: 'Hammer Curl (Dumbbell)', description: 'Biceps'),
        Exercise(name: 'Overhead Curl (Cable)', description: 'Biceps'),
        Exercise(name: 'Preacher Curl', description: 'Biceps'),
        Exercise(name: 'Reverse Curl', description: 'Biceps'),
        Exercise(name: 'Single Arm Curl (Cable)', description: 'Biceps'),
        // Calves
        Exercise(name: 'Calf Press (Machine)', description: 'Calves'),
        Exercise(name: 'Seated Calf Raise', description: 'Calves'),
        Exercise(name: 'Single Leg Standing Calf Raise', description: 'Calves'),
        Exercise(name: 'Single Leg Standing Calf Raise (Machine)', description: 'Calves'),
        Exercise(name: 'Standing Calf Raise (Machine)', description: 'Calves'),
        // Chest
        Exercise(name: 'Bench Press (Barbell)', description: 'Chest'),
        Exercise(name: 'Bench Press (Dumbbell)', description: 'Chest'),
        Exercise(name: 'Bench Press (Smith Machine)', description: 'Chest'),
        Exercise(name: 'Chest Dip', description: 'Chest'),
        Exercise(name: 'Chest Fly (Dumbbell)', description: 'Chest'),
        Exercise(name: 'Incline Bench Press (Barbell)', description: 'Chest'),
        Exercise(name: 'Incline Bench Press (Smith Machine)', description: 'Chest'),
        Exercise(name: 'Incline Chest Fly (Dumbbell)', description: 'Chest'),
        Exercise(name: 'Iso-Lateral Chest (Machine)', description: 'Chest'),
        // Glutes
        Exercise(name: 'Hip Thrust (Barbell)', description: 'Glutes'),
        Exercise(name: 'Hip Thrust (Machine)', description: 'Glutes'),
        // Hamstrings
        Exercise(name: 'Deadlift (Barbell)', description: 'Hamstrings'),
        Exercise(name: 'Lying Leg Curl (Machine)', description: 'Hamstrings'),
        Exercise(name: 'Reverse Lunge (Barbell)', description: 'Hamstrings'),
        Exercise(name: 'Reverse Lunge (Dumbbell)', description: 'Hamstrings'),
        Exercise(name: 'Romanian Deadlift (Barbell)', description: 'Hamstrings'),
        Exercise(name: 'Seated Leg Curl (Machine)', description: 'Hamstrings'),
        // Lats
        Exercise(name: 'Chin Up', description: 'Lats'),
        Exercise(name: 'Chin Up (Weighted)', description: 'Lats'),
        Exercise(name: 'Lat Pulldown - Close Grip (Cable)', description: 'Lats'),
        Exercise(name: 'Lat Pulldown (Cable)', description: 'Lats'),
        Exercise(name: 'Pull Up', description: 'Lats'),
        Exercise(name: 'Pull Up (Weighted)', description: 'Lats'),
        Exercise(name: 'Rope Straight Arm Pulldown', description: 'Lats'),
        // Quadriceps
        Exercise(name: 'Full Squat', description: 'Quadriceps'),
        Exercise(name: 'Hack Squat (Machine)', description: 'Quadriceps'),
        Exercise(name: 'Leg Extension (Machine)', description: 'Quadriceps'),
        Exercise(name: 'Leg Press (Machine)', description: 'Quadriceps'),
        Exercise(name: 'Lunge (Barbell)', description: 'Quadriceps'),
        Exercise(name: 'Lunge (Dumbbell)', description: 'Quadriceps'),
        Exercise(name: 'Pause Squat (Barbell)', description: 'Quadriceps'),
        Exercise(name: 'Pendulum Squat (Machine)', description: 'Quadriceps'),
        Exercise(name: 'Squat (Smith Machine)', description: 'Quadriceps'),
        Exercise(name: 'Squat (Dumbbell)', description: 'Quadriceps'),
        // Shoulders
        Exercise(name: 'Shoulder (Machine Plates)', description: 'Shoulders'),
        Exercise(name: 'Single Arm Lateral Raise (Cable)', description: 'Shoulders'),
        Exercise(name: 'Standing Military Press (Barbell)', description: 'Shoulders'),
        Exercise(name: 'Face Pull', description: 'Shoulders'),
        Exercise(name: 'Lateral Raise (Dumbbell)', description: 'Shoulders'),
        Exercise(name: 'Lateral Raise (Machine)', description: 'Shoulders'),
        Exercise(name: 'Seated Lateral Raise (Dumbbell)', description: 'Shoulders'),
        Exercise(name: 'Seated Press (Dumbbell)', description: 'Shoulders'),
        // Traps
        Exercise(name: 'Shrug (Barbell)', description: 'Traps'),
        Exercise(name: 'Shrug (Dumbbell)', description: 'Traps'),
        // Triceps
        Exercise(name: 'Bench Press - Close Grip', description: 'Triceps'),
        Exercise(name: 'Single Arm Tricep Extension (Dumbbell)', description: 'Triceps'),
        Exercise(name: 'Single Arm Tricep Pushdown (Cable)', description: 'Triceps'),
        Exercise(name: 'Skullcrusher (Dumbbell)', description: 'Triceps'),
        Exercise(name: 'Skullcrusher (Barbell)', description: 'Triceps'),
        Exercise(name: 'Triceps Extension (Cable)', description: 'Triceps'),
        Exercise(name: 'Triceps Pushdown', description: 'Triceps'),
        Exercise(name: 'Triceps Rope Pushdown', description: 'Triceps'),
        // Upper Back
        Exercise(name: 'Seated Cable Row - Bar Grip', description: 'Upper Back'),
        Exercise(name: 'Seated Cable Row - V Grip (Cable)', description: 'Upper Back'),
        Exercise(name: 'Bent Over Row (Barbell)', description: 'Upper Back'),
        Exercise(name: 'Bent Over Row (Dumbbell)', description: 'Upper Back'),
        Exercise(name: 'Rear Delt Reverse Fly (Dumbbell)', description: 'Upper Back'),
        Exercise(name: 'Rear Delt Reverse Fly (Machine)', description: 'Upper Back'),
        Exercise(name: 'Reverse Grip Lat Pulldown (Cable)', description: 'Upper Back'),
      ];
    }

    notifyListeners();
  }
}
