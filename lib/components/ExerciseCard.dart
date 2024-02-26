import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDeleteSuccess;

  ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onDeleteSuccess,
  }) : super(key: key);

  void _deleteEntry(BuildContext context) async {
    try {
      await Amplify.DataStore.delete(exercise);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry deleted successfully!')),
      );
      onDeleteSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Exercise: ${exercise.exercise}", style: TextStyle(fontWeight: FontWeight.bold)),
            // Additional exercise details...
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEntry(context),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onPublishSuccess;

  EditableExerciseCard({
    Key? key,
    required this.exercise,
    required this.onPublishSuccess,
  }) : super(key: key);

  @override
  _EditableExerciseCardState createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _exerciseController;
  late TextEditingController _muscleController;
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;
  DateTime? _selectedDate;

  // Example options for muscles and exercises
  final List<String> _muscles = ['Pecho', 'Hombro', 'Espalda', 'Pierna'];
  Map<String, List<String>> _exercises = {
    'Pecho': ['Press Banca', 'Press Inclinado', 'Aperturas'],
    'Hombro': ['Elevaciones Laterales', 'Press Militar', 'Face Pull'],
    // Add other muscles and exercises as needed
  };
  String? _selectedMuscle;
  String? _selectedExercise;

  @override
  void initState() {
    super.initState();
    _muscleController = TextEditingController();
    _exerciseController = TextEditingController();
    _maxWeightController = TextEditingController();
    _minWeightController = TextEditingController();
    _maxRepsController = TextEditingController();
    _minRepsController = TextEditingController();
    // Set initial values if needed, e.g., from widget.exercise
    _selectedMuscle = widget.exercise.muscle; // Assuming 'muscle' is a String
    _selectedExercise = widget.exercise.exercise; // And 'exercise' as well
    // Initialize _selectedDate with widget.exercise.date if available
  }

  @override
  void dispose() {
    _muscleController.dispose();
    _exerciseController.dispose();
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  void _publishEntry(BuildContext context) async {
    try {
      // Example: Create a new Exercise object with updated details
      // Assuming Exercise class has a constructor that matches these fields
      Exercise updatedExercise = Exercise(
        muscle: _selectedMuscle!,
        exercise: _selectedExercise!,
        // Assign other fields similarly
      );
      // Logic to save or publish `updatedExercise` to the backend
      widget.onPublishSuccess();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Entry published successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error publishing entry: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMuscle,
              items: _muscles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMuscle = value;
                  _selectedExercise = null; // Reset on muscle change
                });
              },
              decoration: InputDecoration(labelText: "Muscle"),
            ),
            if (_selectedMuscle != null) // Only show if a muscle is selected
              DropdownButtonFormField<String>(
                value: _selectedExercise,
                items: _exercises[_selectedMuscle]!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExercise = value;
                  });
                },
                decoration: InputDecoration(labelText: "Exercise"),
              ),
            TextField(
              controller: _maxWeightController,
              decoration: InputDecoration(labelText: "Max Weight"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _minWeightController,
              decoration: InputDecoration(labelText: "Min Weight"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _maxRepsController,
              decoration: InputDecoration(labelText: "Max Reps"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minRepsController,
              decoration: InputDecoration(labelText: "Min Reps"),
              keyboardType: TextInputType.number,
            ),
            ListTile(
              title: Text(_selectedDate == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ElevatedButton(
              onPressed: () => _publishEntry(context),
              child: Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}