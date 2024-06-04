// lib/screens/edit_set_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class EditSetScreen extends StatefulWidget {
  final Workout workout;

  const EditSetScreen({super.key, required this.workout});

  @override
  _EditSetScreenState createState() => _EditSetScreenState();
}

class _EditSetScreenState extends State<EditSetScreen> {
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
        title: Text(appLocalizations!.translate('edit_set')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _repetitions.toString(),
                decoration: InputDecoration(labelText: appLocalizations.translate('repetitions')),
                keyboardType: TextInputType.number,
                onSaved: (value) => _repetitions = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.translate('please_enter_repetitions');
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _weight.toString(),
                decoration: InputDecoration(labelText: appLocalizations.translate('weight_kg')),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations.translate('please_enter_weight');
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _notes,
                decoration: InputDecoration(labelText: appLocalizations.translate('notes')),
                onSaved: (value) => _notes = value!,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
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
                child: Text(appLocalizations.translate('save')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
