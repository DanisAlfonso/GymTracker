// lib/screens/workout_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class WorkoutPreferencesScreen extends StatefulWidget {
  const WorkoutPreferencesScreen({super.key});

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
    final appLocalizations = AppLocalizations.of(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useKg', _useKg);
    await prefs.setInt('defaultRestMinutes', _defaultRestMinutes);
    await prefs.setInt('defaultRestSeconds', _defaultRestSeconds);
    await prefs.setBool('workoutReminders', _workoutReminders);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(appLocalizations?.translate('preferences_saved') ?? 'Preferences saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.translate('workout_preferences') ?? 'Workout Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSwitchListTile(
                title: appLocalizations?.translate('use_kg') ?? 'Use kg',
                value: _useKg,
                onChanged: (value) {
                  setState(() {
                    _useKg = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildSectionHeader(appLocalizations?.translate('default_rest_time') ?? 'Default Rest Time'),
              const SizedBox(height: 10),
              _buildTimePickerRow(context),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: appLocalizations?.translate('enable_workout_reminders') ?? 'Enable workout reminders',
                value: _workoutReminders,
                onChanged: (value) {
                  setState(() {
                    _workoutReminders = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                  child: Text(
                    appLocalizations?.translate('save_preferences') ?? 'Save Preferences',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTimePickerRow(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: appLocalizations?.translate('minutes') ?? 'Minutes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: _defaultRestMinutes.toString(),
                onChanged: (value) {
                  setState(() {
                    _defaultRestMinutes = int.parse(value);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations?.translate('please_enter_minutes') ?? 'Please enter minutes';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: appLocalizations?.translate('seconds') ?? 'Seconds',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: _defaultRestSeconds.toString(),
                onChanged: (value) {
                  setState(() {
                    _defaultRestSeconds = int.parse(value);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations?.translate('please_enter_seconds') ?? 'Please enter seconds';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
