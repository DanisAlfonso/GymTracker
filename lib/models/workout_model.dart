// lib/models/workout_model.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Exercise {
  final String name;
  final String description;
  final String localizationKey;

  Exercise({required this.name, required this.description, required this.localizationKey});

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'localizationKey': localizationKey,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      localizationKey: json['localizationKey'],
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
        Exercise(name: 'Cable Crunch', description: 'Abdominals', localizationKey: 'exercise_cable_crunch'),
        Exercise(name: 'Decline Crunch', description: 'Abdominals', localizationKey: 'exercise_decline_crunch'),
        Exercise(name: 'Hanging Knee Raise', description: 'Abdominals', localizationKey: 'exercise_hanging_knee_raise'),
        Exercise(name: 'Hanging Leg Raise', description: 'Abdominals', localizationKey: 'exercise_hanging_leg_raise'),
        // Adductors
        Exercise(name: 'Hip Adduction (Machine)', description: 'Adductors', localizationKey: 'exercise_hip_adduction_machine'),
        // Biceps
        Exercise(name: 'Concentration Curl', description: 'Biceps', localizationKey: 'exercise_concentration_curl'),
        Exercise(name: 'Bicep Curl (Barbell)', description: 'Biceps', localizationKey: 'exercise_bicep_curl_barbell'),
        Exercise(name: 'Bicep Curl (Cable)', description: 'Biceps', localizationKey: 'exercise_bicep_curl_cable'),
        Exercise(name: 'Seated Incline Curl', description: 'Biceps', localizationKey: 'exercise_seated_incline_curl'),
        Exercise(name: 'EZ Bar Curl', description: 'Biceps', localizationKey: 'exercise_ez_bar_curl'),
        Exercise(name: 'Hammer Curl (Dumbbell)', description: 'Biceps', localizationKey: 'exercise_hammer_curl_dumbbell'),
        Exercise(name: 'Overhead Curl (Cable)', description: 'Biceps', localizationKey: 'exercise_overhead_curl_cable'),
        Exercise(name: 'Preacher Curl', description: 'Biceps', localizationKey: 'exercise_preacher_curl'),
        Exercise(name: 'Reverse Curl', description: 'Biceps', localizationKey: 'exercise_reverse_curl'),
        Exercise(name: 'Single Arm Curl (Cable)', description: 'Biceps', localizationKey: 'exercise_single_arm_curl_cable'),
        // Calves
        Exercise(name: 'Calf Press (Machine)', description: 'Calves', localizationKey: 'exercise_calf_press_machine'),
        Exercise(name: 'Seated Calf Raise', description: 'Calves', localizationKey: 'exercise_seated_calf_raise'),
        Exercise(name: 'Single Leg Standing Calf Raise', description: 'Calves', localizationKey: 'exercise_single_leg_standing_calf_raise'),
        Exercise(name: 'Single Leg Standing Calf Raise (Machine)', description: 'Calves', localizationKey: 'exercise_single_leg_standing_calf_raise_machine'),
        Exercise(name: 'Standing Calf Raise (Machine)', description: 'Calves', localizationKey: 'exercise_standing_calf_raise_machine'),
        // Chest
        Exercise(name: 'Bench Press (Barbell)', description: 'Chest', localizationKey: 'exercise_bench_press_barbell'),
        Exercise(name: 'Bench Press (Dumbbell)', description: 'Chest', localizationKey: 'exercise_bench_press_dumbbell'),
        Exercise(name: 'Bench Press (Smith Machine)', description: 'Chest', localizationKey: 'exercise_bench_press_smith_machine'),
        Exercise(name: 'Chest Dip', description: 'Chest', localizationKey: 'exercise_chest_dip'),
        Exercise(name: 'Chest Fly (Dumbbell)', description: 'Chest', localizationKey: 'exercise_chest_fly_dumbbell'),
        Exercise(name: 'Incline Bench Press (Barbell)', description: 'Chest', localizationKey: 'exercise_incline_bench_press_barbell'),
        Exercise(name: 'Incline Bench Press (Dumbbell)', description: 'Chest', localizationKey: 'exercise_incline_bench_press_dumbbell'),
        Exercise(name: 'Incline Bench Press (Smith Machine)', description: 'Chest', localizationKey: 'exercise_incline_bench_press_smith_machine'),
        Exercise(name: 'Incline Chest Fly (Dumbbell)', description: 'Chest', localizationKey: 'exercise_incline_chest_fly_dumbbell'),
        Exercise(name: 'Iso-Lateral Chest (Machine)', description: 'Chest', localizationKey: 'exercise_iso_lateral_chest_machine'),
        // Glutes
        Exercise(name: 'Hip Thrust (Barbell)', description: 'Glutes', localizationKey: 'exercise_hip_thrust_barbell'),
        Exercise(name: 'Hip Thrust (Machine)', description: 'Glutes', localizationKey: 'exercise_hip_thrust_machine'),
        // Hamstrings
        Exercise(name: 'Deadlift (Barbell)', description: 'Hamstrings', localizationKey: 'exercise_deadlift_barbell'),
        Exercise(name: 'Lying Leg Curl (Machine)', description: 'Hamstrings', localizationKey: 'exercise_lying_leg_curl_machine'),
        Exercise(name: 'Reverse Lunge (Barbell)', description: 'Hamstrings', localizationKey: 'exercise_reverse_lunge_barbell'),
        Exercise(name: 'Reverse Lunge (Dumbbell)', description: 'Hamstrings', localizationKey: 'exercise_reverse_lunge_dumbbell'),
        Exercise(name: 'Romanian Deadlift (Barbell)', description: 'Hamstrings', localizationKey: 'exercise_romanian_deadlift_barbell'),
        Exercise(name: 'Seated Leg Curl (Machine)', description: 'Hamstrings', localizationKey: 'exercise_seated_leg_curl_machine'),
        // Lats
        Exercise(name: 'Chin Up', description: 'Lats', localizationKey: 'exercise_chin_up'),
        Exercise(name: 'Chin Up (Weighted)', description: 'Lats', localizationKey: 'exercise_chin_up_weighted'),
        Exercise(name: 'Lat Pulldown - Close Grip (Cable)', description: 'Lats', localizationKey: 'exercise_lat_pulldown_close_grip_cable'),
        Exercise(name: 'Lat Pulldown (Cable)', description: 'Lats', localizationKey: 'exercise_lat_pulldown_cable'),
        Exercise(name: 'Pull Up', description: 'Lats', localizationKey: 'exercise_pull_up'),
        Exercise(name: 'Pull Up (Weighted)', description: 'Lats', localizationKey: 'exercise_pull_up_weighted'),
        Exercise(name: 'Rope Straight Arm Pulldown', description: 'Lats', localizationKey: 'exercise_rope_straight_arm_pulldown'),
        // Quadriceps
        Exercise(name: 'Full Squat', description: 'Quadriceps', localizationKey: 'exercise_full_squat'),
        Exercise(name: 'Hack Squat (Machine)', description: 'Quadriceps', localizationKey: 'exercise_hack_squat_machine'),
        Exercise(name: 'Leg Extension (Machine)', description: 'Quadriceps', localizationKey: 'exercise_leg_extension_machine'),
        Exercise(name: 'Leg Press (Machine)', description: 'Quadriceps', localizationKey: 'exercise_leg_press_machine'),
        Exercise(name: 'Lunge (Barbell)', description: 'Quadriceps', localizationKey: 'exercise_lunge_barbell'),
        Exercise(name: 'Lunge (Dumbbell)', description: 'Quadriceps', localizationKey: 'exercise_lunge_dumbbell'),
        Exercise(name: 'Pause Squat (Barbell)', description: 'Quadriceps', localizationKey: 'exercise_pause_squat_barbell'),
        Exercise(name: 'Pendulum Squat (Machine)', description: 'Quadriceps', localizationKey: 'exercise_pendulum_squat_machine'),
        Exercise(name: 'Squat (Smith Machine)', description: 'Quadriceps', localizationKey: 'exercise_squat_smith_machine'),
        Exercise(name: 'Squat (Dumbbell)', description: 'Quadriceps', localizationKey: 'exercise_squat_dumbbell'),
        // Shoulders
        Exercise(name: 'Shoulder (Machine Plates)', description: 'Shoulders', localizationKey: 'exercise_shoulder_machine_plates'),
        Exercise(name: 'Single Arm Lateral Raise (Cable)', description: 'Shoulders', localizationKey: 'exercise_single_arm_lateral_raise_cable'),
        Exercise(name: 'Standing Military Press (Barbell)', description: 'Shoulders', localizationKey: 'exercise_standing_military_press_barbell'),
        Exercise(name: 'Face Pull', description: 'Shoulders', localizationKey: 'exercise_face_pull'),
        Exercise(name: 'Lateral Raise (Dumbbell)', description: 'Shoulders', localizationKey: 'exercise_lateral_raise_dumbbell'),
        Exercise(name: 'Lateral Raise (Machine)', description: 'Shoulders', localizationKey: 'exercise_lateral_raise_machine'),
        Exercise(name: 'Seated Lateral Raise (Dumbbell)', description: 'Shoulders', localizationKey: 'exercise_seated_lateral_raise_dumbbell'),
        Exercise(name: 'Seated Press (Dumbbell)', description: 'Shoulders', localizationKey: 'exercise_seated_press_dumbbell'),
        // Traps
        Exercise(name: 'Shrug (Barbell)', description: 'Traps', localizationKey: 'exercise_shrug_barbell'),
        Exercise(name: 'Shrug (Dumbbell)', description: 'Traps', localizationKey: 'exercise_shrug_dumbbell'),
        // Triceps
        Exercise(name: 'Bench Press - Close Grip', description: 'Triceps', localizationKey: 'exercise_bench_press_close_grip'),
        Exercise(name: 'Single Arm Tricep Extension (Dumbbell)', description: 'Triceps', localizationKey: 'exercise_single_arm_tricep_extension_dumbbell'),
        Exercise(name: 'Single Arm Tricep Pushdown (Cable)', description: 'Triceps', localizationKey: 'exercise_single_arm_tricep_pushdown_cable'),
        Exercise(name: 'Skullcrusher (Dumbbell)', description: 'Triceps', localizationKey: 'exercise_skullcrusher_dumbbell'),
        Exercise(name: 'Skullcrusher (Barbell)', description: 'Triceps', localizationKey: 'exercise_skullcrusher_barbell'),
        Exercise(name: 'Triceps Extension (Cable)', description: 'Triceps', localizationKey: 'exercise_triceps_extension_cable'),
        Exercise(name: 'Triceps Pushdown', description: 'Triceps', localizationKey: 'exercise_triceps_pushdown'),
        Exercise(name: 'Triceps Rope Pushdown', description: 'Triceps', localizationKey: 'exercise_triceps_rope_pushdown'),
        // Upper Back
        Exercise(name: 'Seated Cable Row - Bar Grip', description: 'Upper Back', localizationKey: 'exercise_seated_cable_row_bar_grip'),
        Exercise(name: 'Seated Cable Row - V Grip (Cable)', description: 'Upper Back', localizationKey: 'exercise_seated_cable_row_v_grip_cable'),
        Exercise(name: 'Bent Over Row (Barbell)', description: 'Upper Back', localizationKey: 'exercise_bent_over_row_barbell'),
        Exercise(name: 'Bent Over Row (Dumbbell)', description: 'Upper Back', localizationKey: 'exercise_bent_over_row_dumbbell'),
        Exercise(name: 'Rear Delt Reverse Fly (Dumbbell)', description: 'Upper Back', localizationKey: 'exercise_rear_delt_reverse_fly_dumbbell'),
        Exercise(name: 'Rear Delt Reverse Fly (Machine)', description: 'Upper Back', localizationKey: 'exercise_rear_delt_reverse_fly_machine'),
        Exercise(name: 'Reverse Grip Lat Pulldown (Cable)', description: 'Upper Back', localizationKey: 'exercise_reverse_grip_lat_pulldown_cable'),
      ];
    }

    notifyListeners();
  }
}
