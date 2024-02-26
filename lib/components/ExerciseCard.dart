import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            Text("Exercise: ${exercise.exercise}",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
  final String userId;
  final VoidCallback onPublishSuccess;

  EditableExerciseCard(
      {Key? key, required this.userId, required this.onPublishSuccess})
      : super(key: key);

  @override
  _EditableExerciseCardState createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _muscleController;
  late TextEditingController _exerciseController;
  late TextEditingController _dateController;
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;

  // Example options for muscles and exercises
  final List<String> _muscles = ['Pecho', 'Hombro', 'Espalda', 'Pierna'];
  Map<String, List<String>> _exercises = {
    'Pecho': ['Press Banca', 'Press Inclinado', 'Aperturas'],
    'Hombro': ['Elevaciones Laterales', 'Press Militar', 'Face Pull'],
    'Espalda': ['Remo Vertical', 'Remo Horizontal']
    // Add other muscles and exercises as needed
  };
  String? _selectedMuscle;
  String? _selectedExercise;

  @override
  void initState() {
    super.initState();
    _muscleController = TextEditingController(text: 'Hombro');
    _selectedMuscle = 'Hombro';
    _exerciseController = TextEditingController(
        text: ''); // Initialize with empty string if no initial value
    _dateController = _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _maxWeightController = TextEditingController(text: '0');
    _minWeightController = TextEditingController(text: '0');
    _maxRepsController = TextEditingController(text: '0');
    _minRepsController = TextEditingController(text: '0');
  }

  void _publishEntry(context) async {
    // Assuming you have a method to create or update the exercise
    final newExercise = Exercise(
      updatedAt: TemporalDateTime.now(),
      userId: widget.userId,
      date: TemporalDate.fromString(_dateController.text),
      muscle: _muscleController.text,
      exercise: _exerciseController.text,
      maxWeight: double.tryParse(_maxWeightController.text) ?? 0,
      minWeight: double.tryParse(_minWeightController.text) ?? 0,
      maxReps: int.tryParse(_maxRepsController.text) ?? 0,
      minReps: int.tryParse(_minRepsController.text) ?? 0,
    );

    try {
      await Amplify.DataStore.save(newExercise);
      widget.onPublishSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error publishing entry: $e')));
    }
  }

  //dispose the controllers
  @override
  void dispose() {
    _muscleController.dispose();
    _exerciseController.dispose();
    _dateController.dispose();
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('yyyy-MM-dd').parse(_dateController.text),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the dropdowns
    Widget muscleDropdown() {
      return DropdownButtonFormField<String>(
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
            _selectedExercise = null; // Reset exercise when muscle changes
          });
        },
        decoration: InputDecoration(labelText: "Muscle"),
      );
    }

    Widget exerciseDropdown() {
      List<String>? muscleExercises = _exercises[_selectedMuscle];
      bool shouldShow = _selectedMuscle != null && muscleExercises != null;

      return shouldShow ? DropdownButtonFormField<String>(
        value: _selectedExercise,
        items: muscleExercises.map<DropdownMenuItem<String>>((String value) {
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
      ) : Container();
    }
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            muscleDropdown(),
            exerciseDropdown(),
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
              title: Text(_dateController.text == ''
                  ? "Select Date"
                  : _dateController.text),
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
