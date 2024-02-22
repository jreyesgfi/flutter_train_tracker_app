import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/components/ExerciseCard.dart';

import 'package:flutter_application_test1/models/Exercise.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Retrieve the exercises
  List<Exercise> exercises = [];
  String _userId = '';
  late Exercise _newEntry;

  void initializeEntry() async {
    setState(() {
      _newEntry = Exercise(
        updatedAt: TemporalDateTime.now(), // Current timestamp
        userId: _userId, // Placeholder, replace with the actual user ID
        date: TemporalDate.now(), // Example date
        muscle: "Chest", // Example muscle group
        exercise: "Bench Press", // Example exercise
        maxWeight: 100.0, // Example maximum weight
        minWeight: 80.0, // Example minimum weight
        maxReps: 10, // Example maximum repetitions
        minReps: 8, // Example minimum repetitions
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchExercises();
    initializeEntry();
  }

  void fetchUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _userId = user.userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('UserId Error: $e'),
        ),
      );
    }
  }

  void fetchExercises() async {
    try {
      // Assuming you have configured Amplify API or DataStore
      List<Exercise> updatedExercises = await Amplify.DataStore.query(
          Exercise.classType,
          where: Exercise.USERID.eq(_userId));

      // Update the state (triggering a refresh)
      if (mounted) {
        setState(() {
          exercises = updatedExercises;
        });
      }
    } catch (e) {
      Future.microtask(() => {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred while fetching exercises: $e'),
              ),
            )
          });
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // Calculate itemCount: existing exercises + 1 for the new entry form + 1 for the button
    int itemCount =
        exercises.length + 1; // Now only +2 for the form and the button

    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Existing exercises
          if (index < exercises.length) {
            final exercise = exercises[index];
            return ExerciseCard(exercise: exercise,
             onDeleteSuccess: () {fetchExercises();},
             );
          }
          // Placeholder for new entry form
          else if (index == exercises.length) {
            return EditableExerciseCard(exercise: _newEntry,
             onPublishSuccess: () {fetchExercises();initializeEntry();},
             );
          }
        },
      ),
    );
  }
}
