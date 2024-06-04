import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class EditWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const EditWorkoutScreen({super.key, required this.workout});

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _repetitions;
  late double _weight;
  late String _notes;

  @override
  void initState() {
    super.initState();
    _repetitions = widget.workout.repetitions;
    _weight = widget.workout.weight;
    _notes = widget.workout.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final workoutModel = Provider.of<WorkoutModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('edit_workout')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _repetitions.toString(),
                decoration: InputDecoration(
                  labelText: appLocalizations.translate('repetitions'),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _repetitions = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.translate('please_enter_repetitions');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _weight.toString(),
                decoration: InputDecoration(
                  labelText: appLocalizations.translate('weight_kg'),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.translate('please_enter_weight');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _notes,
                decoration: InputDecoration(
                  labelText: appLocalizations.translate('notes'),
                  border: const OutlineInputBorder(),
                ),
                onSaved: (value) => _notes = value!,
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      workoutModel.updateWorkout(
                        widget.workout,
                        _weight,
                        _repetitions,
                        _notes,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(appLocalizations.translate('save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
