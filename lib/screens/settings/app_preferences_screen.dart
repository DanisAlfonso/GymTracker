import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/theme_model.dart';
import '../../app_localizations.dart';

class AppPreferencesScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const AppPreferencesScreen({super.key, required this.onLocaleChange});

  @override
  _AppPreferencesScreenState createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  String _selectedLanguage = 'system';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'system';
    });
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    themeModel.loadPreferences();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    await prefs.setBool('isDarkMode', themeModel.isDark);
    await prefs.setString('selectedLanguage', _selectedLanguage);

    if (_selectedLanguage == 'system') {
      widget.onLocaleChange(WidgetsBinding.instance.window.locale);
    } else {
      widget.onLocaleChange(Locale(_selectedLanguage));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences Saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('preferences')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(appLocalizations.translate('theme'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text(appLocalizations.translate('system_default')),
                  leading: Radio<String>(
                    value: 'system',
                    groupValue: themeModel.themePreference,
                    onChanged: (value) {
                      setState(() {
                        themeModel.setThemePreference(value!);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(appLocalizations.translate('light_mode')),
                  leading: Radio<String>(
                    value: 'light',
                    groupValue: themeModel.themePreference,
                    onChanged: (value) {
                      setState(() {
                        themeModel.setThemePreference(value!);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(appLocalizations.translate('dark_mode')),
                  leading: Radio<String>(
                    value: 'dark',
                    groupValue: themeModel.themePreference,
                    onChanged: (value) {
                      setState(() {
                        themeModel.setThemePreference(value!);
                      });
                    },
                  ),
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
                  items: <String>['system', 'en', 'es', 'fr', 'de'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'system'
                            ? appLocalizations.translate('system_default')
                            : value == 'en'
                            ? 'English'
                            : value == 'es'
                            ? 'Español'
                            : value == 'fr'
                            ? 'Français'
                            : 'Deutsch',
                      ),
                    );
                  }).toList(),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePreferences,
                  child: Text(appLocalizations.translate('save')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
