import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'duration_picker_dialog.dart';
import '../app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final previousSetData = _getPreviousSetData(_setNumber);

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
              if (previousSetData != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: cardBorder,
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations?.translate('previous_performance') ?? 'Previous Performance',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.fitness_center, color: iconColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${previousSetData.repetitions} reps, ${previousSetData.weight} kg',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: iconColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                DateFormat.yMMMd().add_Hm().format(previousSetData.date),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: cardBorder,
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.format_list_numbered, color: iconColor),
                          const SizedBox(width: 8),
                          Text(
                            appLocalizations?.translate('set_number') ?? 'Set Number',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: NumberPicker(
                          minValue: 1,
                          maxValue: 10,
                          value: _setNumber,
                          onChanged: (value) {
                            setState(() {
                              _setNumber = value;
                              _updateInitialValues();
                            });
                          },
                          selectedTextStyle: selectedTextStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      Row(
                        children: [
                          Icon(Icons.repeat, color: iconColor),
                          const SizedBox(width: 8),
                          Text(
                            appLocalizations?.translate('repetitions') ?? 'Repetitions',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: NumberPicker(
                          minValue: 1,
                          maxValue: 100,
                          value: _repetitions,
                          onChanged: (value) {
                            setState(() {
                              _repetitions = value;
                            });
                          },
                          selectedTextStyle: selectedTextStyle,
                          textStyle: textStyle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      Row(
                        children: [
                          Icon(Icons.fitness_center, color: iconColor),
                          const SizedBox(width: 8),
                          Text(
                            appLocalizations?.translate('weight_kg') ?? 'Weight (kg)',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            minValue: 0,
                            maxValue: 1000,
                            value: _weightInt,
                            onChanged: (value) {
                              setState(() {
                                _weightInt = value;
                              });
                            },
                            selectedTextStyle: selectedTextStyle,
                            textStyle: textStyle,
                          ),
                          const Text(
                            '.',
                            style: TextStyle(fontSize: 24, color: Colors.grey),
                          ),
                          NumberPicker(
                            minValue: 0,
                            maxValue: 9,
                            value: _weightDecimal,
                            onChanged: (value) {
                              setState(() {
                                _weightDecimal = value;
                              });
                            },
                            selectedTextStyle: selectedTextStyle,
                            textStyle: textStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            appLocalizations?.translate('add_set') ?? 'Add Set',
                            style: const TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: cardBorder,
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations?.translate('rest_time') ?? 'Rest Time',
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: _pickRestTime,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            '${appLocalizations?.translate('pick_rest_time') ?? 'Pick Rest Time'} (${_restTime.inMinutes} min ${_restTime.inSeconds % 60} sec)',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      Text(
                        appLocalizations?.translate('training_day') ?? 'Training Day',
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: _pickDate,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            DateFormat.yMd().format(_selectedDate),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      Text(
                        appLocalizations?.translate('notes') ?? 'Notes',
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: appLocalizations?.translate('enter_notes') ?? 'Enter notes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
