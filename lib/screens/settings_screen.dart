import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'workout_preferences_screen.dart';
import 'app_preferences_screen.dart';
import 'backup_restore_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Workout Preferences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutPreferencesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('App Preferences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppPreferencesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup and Restore'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BackupRestoreScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
