import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  bool _useSystemTheme = true;

  bool get isDark => _isDark;
  bool get useSystemTheme => _useSystemTheme;

  void setDarkMode(bool isDark) async {
    _isDark = isDark;
    _useSystemTheme = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDark);
    prefs.setBool('useSystemTheme', _useSystemTheme);
  }

  void setUseSystemTheme(bool useSystemTheme) async {
    _useSystemTheme = useSystemTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useSystemTheme', _useSystemTheme);
    if (_useSystemTheme) {
      final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
      setDarkMode(brightness == Brightness.dark);
    }
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDarkMode') ?? false;
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    if (_useSystemTheme) {
      final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
      _isDark = brightness == Brightness.dark;
    }
    notifyListeners();
  }
}
