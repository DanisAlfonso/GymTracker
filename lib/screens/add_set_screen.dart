// add_set_screen.dart
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import 'duration_picker_dialog.dart';

class AddSetScreen extends StatefulWidget {
  final Exercise exercise;

  const AddSetScreen({super.key, required this.exercise});

  @override
  _AddSetScreenState createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  int _repetitions = 1;
  int _weightInt = 0;
  int _weightDecimal = 0;
  Duration _restTime = Duration.zero;

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
        date: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Set'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Repetitions',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
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
                          selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
                          textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text(
                        'Weight (kg)',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            minValue: 0,
                            maxValue: 200,
                            value: _weightInt,
                            onChanged: (value) {
                              setState(() {
                                _weightInt = value;
                              });
                            },
                            selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
                            textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
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
                            selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
                            textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text(
                        'Rest Time',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Pick Rest Time (${_restTime.inMinutes} min ${_restTime.inSeconds % 60} sec)',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text(
                        'Notes',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: 'Enter any notes (optional)',
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
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text(
                            'Add Set',
                            style: TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
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
