// lib/screens/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_localizations.dart'; // Import the AppLocalizations

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _ageController.text = prefs.getInt('age')?.toString() ?? '';
      _weightController.text = prefs.getDouble('weight')?.toString() ?? '';
      _heightController.text = prefs.getDouble('height')?.toString() ?? '';
    });
  }

  Future<void> _saveUserProfile() async {
    final appLocalizations = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setInt('age', int.parse(_ageController.text));
      await prefs.setDouble('weight', double.parse(_weightController.text));
      await prefs.setDouble('height', double.parse(_heightController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations!.translate('profile_saved'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('user_profile')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Implement profile picture selection
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: appLocalizations.translate('name')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations.translate('please_enter_name');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: appLocalizations.translate('age')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations.translate('please_enter_age');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: appLocalizations.translate('weight_kg')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations.translate('please_enter_weight');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: appLocalizations.translate('height_cm')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return appLocalizations.translate('please_enter_height');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserProfile,
                child: Text(appLocalizations.translate('save_profile')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
