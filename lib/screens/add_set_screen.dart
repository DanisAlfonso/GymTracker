import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';
import 'duration_picker_dialog.dart';
import '../app_localizations.dart';
import 'add_set/previous_performance_card.dart';
import 'add_set/set_details_card.dart';
import 'add_set/rest_time_and_notes_card.dart';

class AddSetScreen extends StatefulWidget {
  final Exercise exercise;

  const AddSetScreen({super.key, required this.exercise});

  @override
  _AddSetScreenState createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  int _setNumber = 1;
  int _repetitions = 1;
  int _weightInt = 0;
  int _weightDecimal = 0;
  Duration _restTime = const Duration(minutes: 3);
  DateTime _selectedDate = DateTime.now();
  List<Workout> _previousWorkouts = [];

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
    _fetchPreviousWorkouts();
  }

  Future<void> _fetchPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final minutes = prefs.getInt('defaultRestMinutes') ?? 3;
      final seconds = prefs.getInt('defaultRestSeconds') ?? 0;
      _restTime = Duration(minutes: minutes, seconds: seconds);
    });
  }

  void _fetchPreviousWorkouts() {
    final workoutModel = Provider.of<WorkoutModel>(context, listen: false);
    setState(() {
      _previousWorkouts = workoutModel.workouts
          .where((workout) => workout.exercise.name == widget.exercise.name)
          .toList();
    });
    _updateInitialValues();
  }

  void _updateInitialValues() {
    final previousSetData = _getPreviousSetData(_setNumber);
    if (previousSetData != null) {
      setState(() {
        _repetitions = previousSetData.repetitions;
        _weightInt = previousSetData.weight.toInt();
        _weightDecimal = ((previousSetData.weight - _weightInt) * 10).round();
      });
    }
  }

  Workout? _getPreviousSetData(int setNumber) {
    if (_previousWorkouts.isEmpty) return null;

    Map<DateTime, List<Workout>> groupedWorkouts = {};
    for (var workout in _previousWorkouts) {
      DateTime date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      if (!groupedWorkouts.containsKey(date)) {
        groupedWorkouts[date] = [];
      }
      groupedWorkouts[date]!.add(workout);
    }

    DateTime? latestDate = groupedWorkouts.keys.isNotEmpty
        ? groupedWorkouts.keys.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    if (latestDate == null) return null;

    List<Workout> latestWorkouts = groupedWorkouts[latestDate]!;
    latestWorkouts.sort((a, b) => a.date.compareTo(b.date));

    return setNumber <= latestWorkouts.length ? latestWorkouts[setNumber - 1] : null;
  }

  List<Workout> _getLatestWorkouts() {
    if (_previousWorkouts.isEmpty) return [];

    Map<DateTime, List<Workout>> groupedWorkouts = {};
    for (var workout in _previousWorkouts) {
      DateTime date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      if (!groupedWorkouts.containsKey(date)) {
        groupedWorkouts[date] = [];
      }
      groupedWorkouts[date]!.add(workout);
    }

    DateTime? latestDate = groupedWorkouts.keys.isNotEmpty
        ? groupedWorkouts.keys.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    return latestDate != null ? groupedWorkouts[latestDate]! : [];
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = _weightInt + (_weightDecimal / 10.0);
      final notes = _notesController.text.isEmpty ? null : _notesController.text;

      final workout = Workout(
        exercise: widget.exercise,
        repetitions: _repetitions,
        weight: weight,
        restTime: _restTime,
        notes: notes,
        date: _selectedDate,
      );

      Provider.of<WorkoutModel>(context, listen: false).addWorkout(workout);

      Navigator.pop(context);
    }
  }

  Future<void> _pickRestTime() async {
    final pickedTime = await showDialog<Duration>(
      context: context,
      builder: (context) => DurationPickerDialog(
        initialMinutes: _restTime.inMinutes,
        initialSeconds: _restTime.inSeconds % 60,
      ),
    );

    if (pickedTime != null) {
      setState(() {
        _restTime = pickedTime;
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final iconColor = isDarkMode ? Colors.white : primaryColor;
    final selectedTextStyle = TextStyle(color: iconColor, fontSize: 32, fontWeight: FontWeight.bold);
    final textStyle = TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey, fontSize: 18);
    final cardBorder = BorderSide(color: theme.dividerColor.withOpacity(0.5));

    final latestWorkouts = _getLatestWorkouts();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.translate('add_set') ?? 'Add Set'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (latestWorkouts.isNotEmpty)
                PreviousPerformanceCard(
                  previousWorkouts: latestWorkouts,
                  iconColor: iconColor,
                  cardBorder: cardBorder,
                ),
              SetDetailsCard(
                setNumber: _setNumber,
                repetitions: _repetitions,
                weightInt: _weightInt,
                weightDecimal: _weightDecimal,
                selectedTextStyle: selectedTextStyle,
                textStyle: textStyle,
                iconColor: iconColor,
                cardBorder: cardBorder,
                onSetNumberChanged: (value) {
                  setState(() {
                    _setNumber = value;
                    _updateInitialValues();
                  });
                },
                onRepetitionsChanged: (value) {
                  setState(() {
                    _repetitions = value;
                  });
                },
                onWeightIntChanged: (value) {
                  setState(() {
                    _weightInt = value;
                  });
                },
                onWeightDecimalChanged: (value) {
                  setState(() {
                    _weightDecimal = value;
                  });
                },
                onSubmit: _submit,
              ),
              RestTimeAndNotesCard(
                restTime: _restTime,
                selectedDate: _selectedDate,
                notesController: _notesController,
                onPickRestTime: _pickRestTime,
                onPickDate: _pickDate,
                iconColor: iconColor,
                cardBorder: cardBorder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
