import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/components/ExerciseCard.dart';
import 'package:flutter_application_test1/components/MuscleDateSelector.dart'; // Ensure this import is correct
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Exercise> exercises = [];
  String _userId = '';
  bool _needToFetch = false;

  @override
  void initState() {
    super.initState();
    fetchUserId();
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

    void triggerFetch() {
    setState(() {
      _needToFetch = true;
    });
  }

  void resetFetchFlag() {
    setState(() {
      _needToFetch = false;
    });
  }

  void updateExercises(List<Exercise> finalExercises) async {
      // Update the state with the filtered exercises.
      if (mounted) {
        setState(() {
          exercises = finalExercises;
          _needToFetch = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MuscleDateSelectionModel>(
      create: (context)=>MuscleDateSelectionModel(),
    child: Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Column(
        children: [
          MuscleDateSelector(
            onExercisesFetched: updateExercises,
            needToFetch: _needToFetch,
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
                    onPublishSuccess: triggerFetch,
                  );
                } else {
                  // Adjust index by -1 because the first item is the EditableExerciseCard
                  final exercise = exercises[index - 1];
                  return ExerciseCard(
                    exercise: exercise,
                    onDeleteSuccess: triggerFetch,
                  );
                }
              },
            ),
          ),
        ],
      ),
    )
    );
  }
}

class MuscleDateSelectionModel extends ChangeNotifier{
  String _selectedMuscle = '';
  DateTime _selectedDate = DateTime.now();

  // Getter
  String get selectedMuscle => _selectedMuscle;
  DateTime get selectedDate => _selectedDate;
  
  // Setter
  void updateDate(DateTime newDate) {
    _selectedDate = newDate;
  }
  void updateMuscle(String newMuscle) {
    _selectedMuscle = newMuscle;
    notifyListeners();
  }
}