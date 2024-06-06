// lib/screens/statistics/calculate_one_rep_max.dart
import 'package:flutter/material.dart';
import '../../app_localizations.dart'; // Import the AppLocalizations

class CalculateOneRepMax extends StatefulWidget {
  const CalculateOneRepMax({super.key});

  @override
  _CalculateOneRepMaxState createState() => _CalculateOneRepMaxState();
}

class _CalculateOneRepMaxState extends State<CalculateOneRepMax> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  double? _oneRepMax;
  Map<String, double>? _percentages;
  Map<String, int>? _reps;

  void _calculateOneRepMax() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final int reps = int.tryParse(_repsController.text) ?? 0;
    if (weight > 0 && reps > 0) {
      setState(() {
        _oneRepMax = weight * (1 + reps / 30.0);
        _percentages = {
          '100%': _oneRepMax!,
          '95%': _oneRepMax! * 0.95,
          '90%': _oneRepMax! * 0.90,
          '85%': _oneRepMax! * 0.85,
          '80%': _oneRepMax! * 0.80,
          '75%': _oneRepMax! * 0.75,
          '70%': _oneRepMax! * 0.70,
          '65%': _oneRepMax! * 0.65,
          '60%': _oneRepMax! * 0.60,
          '55%': _oneRepMax! * 0.55,
          '50%': _oneRepMax! * 0.50,
        };
        _reps = {
          '100%': 1,
          '95%': (30 * (1 / 0.95 - 1)).round(),
          '90%': (30 * (1 / 0.90 - 1)).round(),
          '85%': (30 * (1 / 0.85 - 1)).round(),
          '80%': (30 * (1 / 0.80 - 1)).round(),
          '75%': (30 * (1 / 0.75 - 1)).round(),
          '70%': (30 * (1 / 0.70 - 1)).round(),
          '65%': (30 * (1 / 0.65 - 1)).round(),
          '60%': (30 * (1 / 0.60 - 1)).round(),
          '55%': (30 * (1 / 0.55 - 1)).round(),
          '50%': (30 * (1 / 0.50 - 1)).round(),
        };
      });
    } else {
      setState(() {
        _oneRepMax = null;
        _percentages = null;
        _reps = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations?.translate('calculate_one_rep_max') ?? 'Calculate One-Rep Max',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          decoration: InputDecoration(
            labelText: appLocalizations?.translate('weight') ?? 'Weight',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _repsController,
          decoration: InputDecoration(
            labelText: appLocalizations?.translate('reps') ?? 'Reps',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _calculateOneRepMax,
          child: Text(appLocalizations?.translate('calculate') ?? 'Calculate'),
        ),
        if (_oneRepMax != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appLocalizations?.translate('one_rep_max') ?? 'One-Rep Max'}: ${_oneRepMax!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Percentage')),
                    DataColumn(label: Text('Weight')),
                    DataColumn(label: Text('Reps')),
                  ],
                  rows: _percentages!.entries.map((entry) {
                    final reps = _reps![entry.key] ?? 0;
                    return DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(Text(entry.value.toStringAsFixed(2))),
                      DataCell(Text(reps.toString())),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
