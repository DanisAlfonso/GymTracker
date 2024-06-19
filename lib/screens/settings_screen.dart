// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'settings/user_profile_screen.dart';
import 'settings/workout_preferences_screen.dart';
import 'settings/app_preferences_screen.dart';
import 'settings/backup_restore_screen.dart';
import 'settings/about_screen.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class SettingsScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const SettingsScreen({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardBorder = BorderSide(color: theme.dividerColor.withOpacity(0.5));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: cardBorder,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.person,
                  text: appLocalizations.translate('user_profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                    );
                  },
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                Divider(color: theme.dividerColor.withOpacity(0.5)),
                _buildSettingsTile(
                  context,
                  icon: Icons.fitness_center,
                  text: appLocalizations.translate('workout_preferences'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkoutPreferencesScreen()),
                    );
                  },
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                Divider(color: theme.dividerColor.withOpacity(0.5)),
                _buildSettingsTile(
                  context,
                  icon: Icons.settings,
                  text: appLocalizations.translate('app_preferences'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppPreferencesScreen(onLocaleChange: onLocaleChange)),
                    );
                  },
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                Divider(color: theme.dividerColor.withOpacity(0.5)),
                _buildSettingsTile(
                  context,
                  icon: Icons.backup,
                  text: appLocalizations.translate('backup_restore'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BackupRestoreScreen()),
                    );
                  },
                  iconColor: iconColor,
                  textColor: textColor,
                ),
                Divider(color: theme.dividerColor.withOpacity(0.5)),
                _buildSettingsTile(
                  context,
                  icon: Icons.info,
                  text: appLocalizations.translate('about'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    );
                  },
                  iconColor: iconColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap, required Color iconColor, required Color textColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
