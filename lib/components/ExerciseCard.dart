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
  // Initialize other controllers as needed

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(text: widget.exercise.exercise);
    _muscleController = TextEditingController(text: widget.exercise.muscle);
    // Initialize other fields
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _muscleController.dispose();
    // Dispose other controllers
    super.dispose();
  }

  void _publishEntry(BuildContext context) async {
    try {
      // Example: Create a new Exercise object with updated details
      // Save or publish it to the backend
      widget.onPublishSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry published successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing entry: $e')),
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
            TextField(
              controller: _exerciseController,
              decoration: InputDecoration(labelText: "Exercise"),
            ),
            TextField(
              controller: _muscleController,
              decoration: InputDecoration(labelText: "Muscle"),
            ),
            // Additional editable fields...
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
