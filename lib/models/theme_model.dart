import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  String _themePreference = 'system'; // Can be 'system', 'light', or 'dark'

  bool get isDark => _isDark;
  String get themePreference => _themePreference;

  void setThemePreference(String preference) async {
    _themePreference = preference;
    if (_themePreference == 'system') {
      final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
      _isDark = brightness == Brightness.dark;
    } else {
      _isDark = _themePreference == 'dark';
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themePreference', _themePreference);
    prefs.setBool('isDarkMode', _isDark);
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themePreference = prefs.getString('themePreference') ?? 'system';
    if (_themePreference == 'system') {
      final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
      _isDark = brightness == Brightness.dark;
    } else {
      _isDark = _themePreference == 'dark';
    }
    notifyListeners();
  }
}
