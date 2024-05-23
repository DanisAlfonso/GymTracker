import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'training_screen.dart';
import 'create_routine_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCreateRoutineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const CreateRoutineScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingScreen()),
                );
              },
              child: const Text('Training'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateRoutineSheet(context),
        label: const Text('New Routine'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
