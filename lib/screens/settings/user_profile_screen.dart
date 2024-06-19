import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import '../../app_localizations.dart';

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
  File? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? prefs.getString('name') ?? '';
          _ageController.text = data['age']?.toString() ?? prefs.getInt('age')?.toString() ?? '';
          _weightController.text = data['weight']?.toString() ?? prefs.getDouble('weight')?.toString() ?? '';
          _heightController.text = data['height']?.toString() ?? prefs.getDouble('height')?.toString() ?? '';
          _profileImageUrl = data['profileImageUrl'] ?? prefs.getString('profileImageUrl');
        });
      }
    } else {
      setState(() {
        _nameController.text = prefs.getString('name') ?? '';
        _ageController.text = prefs.getInt('age')?.toString() ?? '';
        _weightController.text = prefs.getDouble('weight')?.toString() ?? '';
        _heightController.text = prefs.getDouble('height')?.toString() ?? '';
        _profileImageUrl = prefs.getString('profileImageUrl');
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final appLocalizations = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setInt('age', int.parse(_ageController.text));
      await prefs.setDouble('weight', double.parse(_weightController.text));
      await prefs.setDouble('height', double.parse(_heightController.text));
      if (_profileImageUrl != null) {
        await prefs.setString('profileImageUrl', _profileImageUrl!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations!.translate('profile_saved'))),
      );

      // Save to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'weight': double.parse(_weightController.text),
          'height': double.parse(_heightController.text),
          'profileImageUrl': _profileImageUrl,
        }, SetOptions(merge: true));
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Compress the image
      final compressedImage = await compressImage(imageFile);

      setState(() {
        _profileImage = compressedImage;
      });
      await _uploadImageToFirebase();
    }
  }

  Future<File> compressImage(File imageFile) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    final compressedImage = img.copyResize(originalImage!, width: 500);
    final compressedFile = File('${imageFile.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(compressedImage, quality: 85));
    return compressedFile;
  }

  Future<void> _uploadImageToFirebase() async {
    if (_profileImage == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('${user.uid}.jpg');

      await ref.putFile(_profileImage!);
      final url = await ref.getDownloadURL();

      if (mounted) {
        setState(() {
          _profileImageUrl = url;
        });
      }

      // Save the URL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'profileImageUrl': _profileImageUrl,
      });
    } catch (e) {
      print('Failed to upload image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : theme.primaryColor;
    final avatarBackgroundColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('user_profile')),
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: avatarBackgroundColor,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : null) as ImageProvider?,
                        child: _profileImage == null && _profileImageUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Increased height
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('name'),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : theme.primaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return appLocalizations.translate('please_enter_name');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30), // Increased height
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('age'),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : theme.primaryColor,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return appLocalizations.translate('please_enter_age');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30), // Increased height
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('weight_kg'),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : theme.primaryColor,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return appLocalizations.translate('please_enter_weight');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30), // Increased height
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.translate('height_cm'),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : theme.primaryColor,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return appLocalizations.translate('please_enter_height');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30), // Increased height
                  ElevatedButton.icon(
                    onPressed: _saveUserProfile,
                    icon: Icon(Icons.save, color: isDarkMode ? Colors.white : Colors.white),
                    label: Text(
                      appLocalizations.translate('save_profile'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(appLocalizations.translate('logout')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
      ),
    );
  }
}
