// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'workout_preferences_screen.dart';
import 'app_preferences_screen.dart';
import 'backup_restore_screen.dart';
import 'about_screen.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class SettingsScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(appLocalizations.translate('user_profile')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(appLocalizations.translate('workout_preferences')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutPreferencesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(appLocalizations.translate('app_preferences')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppPreferencesScreen(onLocaleChange: onLocaleChange)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(appLocalizations.translate('backup_restore')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BackupRestoreScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(appLocalizations.translate('about')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}