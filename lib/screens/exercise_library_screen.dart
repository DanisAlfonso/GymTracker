import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../app_localizations.dart'; // Import AppLocalizations

class ExerciseLibraryScreen extends StatefulWidget {
  final List<Exercise> selectedExercises;

  const ExerciseLibraryScreen({super.key, required this.selectedExercises});

  @override
  _ExerciseLibraryScreenState createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  late List<Exercise> _selectedExercises;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedExercises = List.from(widget.selectedExercises); // Make a mutable copy
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(Exercise exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  List<Exercise> _filterExercises(List<Exercise> exercises) {
    if (_searchQuery.isEmpty) {
      return exercises;
    } else {
      return exercises.where((exercise) {
        final appLocalizations = AppLocalizations.of(context);
        final exerciseName = appLocalizations!.translate('${exercise.localizationKey}_name');
        final exerciseDescription = appLocalizations.translate('${exercise.localizationKey}_description');
        return exerciseName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            exerciseDescription.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<WorkoutModel>(context).exercises;
    final appLocalizations = AppLocalizations.of(context);

    // Group exercises by category
    final Map<String, List<Exercise>> groupedExercises = {};
    for (var exercise in _filterExercises(exercises)) {
      final category = appLocalizations!.translate('${exercise.localizationKey}_description');
      if (groupedExercises[category] == null) {
        groupedExercises[category] = [];
      }
      groupedExercises[category]!.add(exercise);
    }

    // Sort muscle groups alphabetically
    final sortedKeys = groupedExercises.keys.toList()..sort();

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : theme.primaryColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardBorder = BorderSide(color: theme.dividerColor.withOpacity(0.5));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.translate('exercise_library')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: appLocalizations.translate('search'),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: sortedKeys.map((key) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: cardBorder,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          key,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        collapsedBackgroundColor: theme.cardColor, // Set background color to match card color
                        backgroundColor: theme.cardColor, // Set background color to match card color
                        children: groupedExercises[key]!.map((exercise) {
                          final isSelected = _selectedExercises.contains(exercise);
                          return ListTile(
                            title: Text(appLocalizations.translate('${exercise.localizationKey}_name')),
                            trailing: Icon(
                              isSelected ? Icons.check_circle : Icons.check_circle_outline,
                              color: isSelected ? Colors.green : Colors.grey,
                            ),
                            onTap: () => _toggleSelection(exercise),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, _selectedExercises);
        },
        icon: const Icon(Icons.check),
        label: const Text('Done'),
      ),
    );
  }
}

class AddExerciseDialog extends StatefulWidget {
  const AddExerciseDialog({super.key});

  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _recoveryTimeController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final exercise = Exercise(
        name: _nameController.text,
        description: _descriptionController.text,
        localizationKey: '', // Provide an empty localization key for custom exercises
        recoveryTimeInHours: int.parse(_recoveryTimeController.text),
      );

      Provider.of<WorkoutModel>(context, listen: false).addCustomExercise(exercise);
      Navigator.pop(context, exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(appLocalizations!.translate('add_exercise')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: appLocalizations.translate('name')),
              validator: (value) {
                if (value!.isEmpty) {
                  return appLocalizations.translate('please_enter_exercise_name');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: appLocalizations.translate('description')),
              validator: (value) {
                if (value!.isEmpty) {
                  return appLocalizations.translate('please_enter_exercise_description');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _recoveryTimeController,
              decoration: InputDecoration(labelText: appLocalizations.translate('recovery_time')),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return appLocalizations.translate('please_enter_recovery_time');
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(appLocalizations.translate('cancel')),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(appLocalizations.translate('add')),
        ),
      ],
    );
  }
}
