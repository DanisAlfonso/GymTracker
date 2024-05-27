import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/workout_model.dart';
import 'models/theme_model.dart';
import 'screens/home_screen.dart';
import 'screens/training_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await clearSharedPreferences(); // Temporarily clear shared preferences for testing - Remove or comment out this line
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()..loadPreferences()),
      ],
      child: const MyApp(),
    ),
  );
}

/* Future<void> clearSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
} */

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'en';
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
            Locale('fr', ''),
            Locale('de', ''),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: themeModel.isDark ? Brightness.dark : Brightness.light,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: themeModel.isDark ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeModel.isDark ? Colors.white : Colors.blue,
                ),
              ),
            ),
          ),
          home: MainScreen(onLocaleChange: _setLocale),
          routes: {
            '/settings': (context) => SettingsScreen(onLocaleChange: _setLocale),
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const MainScreen({super.key, required this.onLocaleChange});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions(BuildContext context) {
    return [
      const HomeScreen(),
      const TrainingScreen(),
      const StatisticsScreen(),
      SettingsScreen(onLocaleChange: widget.onLocaleChange),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions(context),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
