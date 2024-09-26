import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/temp/ExerciseCard.dart';
import 'package:gymini/presentation_layer/temp/MuscleDateSelector.dart'; // Ensure this import is correct
import 'package:gymini/models/Exercise.dart';
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

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  @override
  void dispose() {
    // Clean up listener
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ExerciseProvider()),
      ChangeNotifierProvider(
          create: (context) => MuscleDateSelectionProvider()),
    ], child: mainScreenUI());
  }

  Widget mainScreenUI() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 4,
        ),
        body: Consumer<ExerciseProvider>(
            builder: (context, exerciseProvider, child) {
          return Column(
            children: [
              const MuscleDateSelector(),
              EditableExerciseCard(
                userId: _userId,
                onPublishSuccess: exerciseProvider.fetch,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: exerciseProvider.allExercises.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseProvider.allExercises[index];
                  return ExerciseCard(
                    exercise: exercise,
                    onDeleteSuccess: exerciseProvider.fetch,
                  );
                },
              )),
            ],
          );
        }));
  }
}

class MuscleDateSelectionProvider extends ChangeNotifier {
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

// Inside ExerciseProvider

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> _allExercises = [];
  bool _needToFetch = true;

  // Getters
  List<Exercise> get allExercises => _allExercises;
  bool get needToFetch => _needToFetch;

  // Setter
  void updateAllExercises(List<Exercise> exercises) {
    _allExercises = exercises;
    _needToFetch = false;
    notifyListeners();
  }

  void fetch() {
    _needToFetch = true;
    notifyListeners();
  }
}
