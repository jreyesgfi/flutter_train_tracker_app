import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MuscleDateSelector extends StatefulWidget {
  final ValueChanged<String?> onMuscleChanged;
  final ValueChanged<DateTime?> onDateChanged;

  const MuscleDateSelector({
    Key? key,
    required this.onMuscleChanged,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  _MuscleDateSelectorState createState() => _MuscleDateSelectorState();
}

class _MuscleDateSelectorState extends State<MuscleDateSelector> {
  String? _selectedMuscle;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          // Muscle Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedMuscle,
              onChanged: (newValue) {
                setState(() {
                  _selectedMuscle = newValue;
                });
                widget.onMuscleChanged(newValue);
              },
              items: const [
                DropdownMenuItem(value: 'Pecho', child: Text('Pecho')),
                DropdownMenuItem(value: 'Hombro', child: Text('Hombro')),
                // Add other muscles as DropdownMenuItem
              ],
              decoration: InputDecoration(labelText: "Select Muscle"),
            ),
          ),
          // Date Picker
          Expanded(
            child: TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                  widget.onDateChanged(picked);
                }
              },
              child: Text(_selectedDate == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
            ),
          ),
        ],
      ),
    );
  }
}
