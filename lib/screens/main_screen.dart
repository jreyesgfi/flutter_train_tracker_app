import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/components/ExerciseCard.dart';
import 'package:flutter_application_test1/components/MuscleDateSelector.dart'; // Ensure this import is correct
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:intl/intl.dart'; // For date formatting

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Exercise> exercises = [];
  String _userId = '';
  DateTime _selectedDate = DateTime.now(); // Default to current date
  String _selectedMuscle = 'Hombro';

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchExercises(); // Initially fetch all exercises
  }

  void fetchUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _userId = user.userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('UserId Error: $e')),
      );
    }
  }

  void fetchExercises({String? muscle, DateTime? selectedDate}) async {
    try {
      // Fetch exercises from the DataStore based only on the user ID.
      List<Exercise> allExercises = await Amplify.DataStore.query(
        Exercise.classType,
        where: Exercise.USERID.eq(_userId),
      );

      // If a muscle is specified, manually filter the exercises by muscle.
      if (muscle != null) {
        allExercises = allExercises
            .where((exercise) => exercise.muscle == muscle)
            .toList();
      }

      // Convert selectedDate to TemporalDate for comparison, if present.
      TemporalDate? temporalSelectedDate =
          selectedDate != null ? TemporalDate(selectedDate) : null;

      // Further filter the fetched exercises by date, if a date is specified.
      if (temporalSelectedDate != null) {
        allExercises =
            filterExercisesByDate(allExercises, temporalSelectedDate);
      }
      // Sort With Date Descending
      allExercises.sort((a, b) => b.date.compareTo(a.date));

      // Update the state with the filtered exercises.
      if (mounted) {
        setState(() {
          exercises = allExercises;
        });
      }
    } catch (e) {
      print('Error fetching exercises: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while fetching exercises: $e')),
      );
    }
  }

  List<Exercise> filterExercisesByDate(
      List<Exercise> exercises, TemporalDate selectedDate) {
    TemporalDate? latestDateBeforeSelected;

    for (var exercise in exercises) {
      TemporalDate exerciseDate = exercise.date; // Now using TemporalDate
      if (exerciseDate.compareTo(selectedDate) < 0) {
        // compareTo returns a negative value if exerciseDate is before selectedDate
        if (latestDateBeforeSelected == null ||
            exerciseDate.compareTo(latestDateBeforeSelected) > 0) {
          latestDateBeforeSelected = exerciseDate;
        }
      }
    }

    if (latestDateBeforeSelected != null) {
      return exercises
          .where((exercise) =>
              exercise.date.compareTo(latestDateBeforeSelected!) == 0 ||
              exercise.date.compareTo(selectedDate) == 0)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Column(
        children: [
          MuscleDateSelector(
            onMuscleChanged: (muscle) {
              _selectedMuscle = muscle!;
              fetchExercises(muscle: muscle, selectedDate: _selectedDate);
            },
            onDateChanged: (date) {
              _selectedDate = date!;
              fetchExercises(muscle: _selectedMuscle, selectedDate: date);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  exercises.length + 1, // +1 for the EditableExerciseCard
              itemBuilder: (context, index) {
                if (index == 0) {
                  // EditableExerciseCard always at the top
                  return EditableExerciseCard(
                    userId: _userId,
                    selectedDate: _selectedDate,
                    selectedMuscle: _selectedMuscle,
                    onPublishSuccess: () => fetchExercises(
                        muscle: _selectedMuscle, selectedDate: _selectedDate),
                  );
                } else {
                  // Adjust index by -1 because the first item is the EditableExerciseCard
                  final exercise = exercises[index - 1];
                  return ExerciseCard(
                    exercise: exercise,
                    onDeleteSuccess: () => fetchExercises(
                        muscle: _selectedMuscle, selectedDate: _selectedDate),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
