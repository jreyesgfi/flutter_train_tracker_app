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
  late TextEditingController _exerciseController;
  late TextEditingController _muscleController;
  late TextEditingController _dateController;
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(
        text: ''); // Initialize with empty string if no initial value
    _muscleController = TextEditingController(text: '');
    _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(DateTime.now())); // Today's date as default
    _maxWeightController = TextEditingController(text: '0');
    _minWeightController = TextEditingController(text: '0');
    _maxRepsController = TextEditingController(text: '0');
    _minRepsController = TextEditingController(text: '0');
  }

  void _publishEntry() async {
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

  Widget _buildMuscleGroupDropdown() {
    List<String> muscleGroups = ['Chest', 'Back', 'Legs'];
    return DropdownButtonFormField<String>(
      value: muscleGroups.contains(_muscleController.text)
          ? _muscleController.text
          : null,
      decoration: InputDecoration(labelText: 'Muscle Group'),
      items: muscleGroups.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _muscleController.text = newValue ?? '';
          _exerciseController.clear(); // Reset exercise when muscle changes
        });
      },
    );
  }

  Widget _buildExerciseDropdown() {
    Map<String, List<String>> exercisesByMuscle = {
      'Chest': ['Bench Press', 'Dumbbell Flyes'],
      'Back': ['Pull Ups', 'Deadlifts'],
      'Legs': ['Squats', 'Leg Press'],
    };
    List<String> exercises = _muscleController.text.isNotEmpty
        ? exercisesByMuscle[_muscleController.text] ?? []
        : [];

    return DropdownButtonFormField<String>(
      value: exercises.contains(_exerciseController.text)
          ? _exerciseController.text
          : null,
      decoration: InputDecoration(labelText: 'Exercise'),
      items: exercises.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _exerciseController.text = newValue ?? '';
        });
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Edit Exercise'),
    ),
    body: SingleChildScrollView( // This will allow vertical scrolling
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ... Your other widgets
          TextFormField(
            controller: _maxRepsController,
            decoration: InputDecoration(labelText: 'Max Reps'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _minRepsController,
            decoration: InputDecoration(labelText: 'Min Reps'),
            keyboardType: TextInputType.number,
          ),
          // ... Any additional fields
        ],
      ),
    ),
  );
}

  //dispose the controllers
  @override
  void dispose() {
    _exerciseController.dispose();
    _muscleController.dispose();
    _dateController.dispose();
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }
}
