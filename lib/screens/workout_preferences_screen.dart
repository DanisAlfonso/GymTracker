import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPreferencesScreen extends StatefulWidget {
  @override
  _WorkoutPreferencesScreenState createState() => _WorkoutPreferencesScreenState();
}

class _WorkoutPreferencesScreenState extends State<WorkoutPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _useKg = true;
  int _defaultRestMinutes = 1;
  int _defaultRestSeconds = 30;
  bool _workoutReminders = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useKg = prefs.getBool('useKg') ?? true;
      _defaultRestMinutes = prefs.getInt('defaultRestMinutes') ?? 1;
      _defaultRestSeconds = prefs.getInt('defaultRestSeconds') ?? 30;
      _workoutReminders = prefs.getBool('workoutReminders') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useKg', _useKg);
    await prefs.setInt('defaultRestMinutes', _defaultRestMinutes);
    await prefs.setInt('defaultRestSeconds', _defaultRestSeconds);
    await prefs.setBool('workoutReminders', _workoutReminders);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences Saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                title: Text('Use Kilograms (kg)'),
                value: _useKg,
                onChanged: (bool value) {
                  setState(() {
                    _useKg = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text('Default Rest Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Minutes'),
                      keyboardType: TextInputType.number,
                      initialValue: _defaultRestMinutes.toString(),
                      onChanged: (value) {
                        setState(() {
                          _defaultRestMinutes = int.parse(value);
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter minutes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Seconds'),
                      keyboardType: TextInputType.number,
                      initialValue: _defaultRestSeconds.toString(),
                      onChanged: (value) {
                        setState(() {
                          _defaultRestSeconds = int.parse(value);
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter seconds';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text('Enable Workout Reminders'),
                value: _workoutReminders,
                onChanged: (bool value) {
                  setState(() {
                    _workoutReminders = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePreferences,
                child: Text('Save Preferences'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
