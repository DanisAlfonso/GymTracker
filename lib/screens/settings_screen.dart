import 'package:flutter/material.dart';

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
              // Navigate to User Profile screen
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Workout Preferences'),
            onTap: () {
              // Navigate to Workout Preferences screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('App Preferences'),
            onTap: () {
              // Navigate to App Preferences screen
            },
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup and Restore'),
            onTap: () {
              // Navigate to Backup and Restore screen
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Navigate to About screen
            },
          ),
        ],
      ),
    );
  }
}
