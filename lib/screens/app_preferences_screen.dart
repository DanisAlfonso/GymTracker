import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_model.dart';
import '../app_localizations.dart';

class AppPreferencesScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const AppPreferencesScreen({super.key, required this.onLocaleChange});

  @override
  _AppPreferencesScreenState createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    });
    Provider.of<ThemeModel>(context, listen: false)
        .setDarkMode(prefs.getBool('isDarkMode') ?? false);
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', Provider.of<ThemeModel>(context, listen: false).isDark);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('selectedLanguage', _selectedLanguage);
    widget.onLocaleChange(Locale(_selectedLanguage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences Saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('preferences')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(appLocalizations.translate('dark_mode')),
              value: themeModel.isDark,
              onChanged: (bool value) {
                themeModel.setDarkMode(value);
              },
            ),
            SwitchListTile(
              title: Text(appLocalizations.translate('notifications')),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(appLocalizations.translate('language'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: <String>['en', 'es', 'fr', 'de'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'en' ? 'English' : value == 'es' ? 'Español' : value == 'fr' ? 'Français' : 'Deutsch'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePreferences,
              child: Text(appLocalizations.translate('save')),
            ),
          ],
        ),
      ),
    );
  }
}
