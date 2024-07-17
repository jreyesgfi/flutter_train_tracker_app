//provider
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_application_test1/domain_layer/entities/session_info.dart'; // Assuming this is where SessionInfoSchema is defined

class TrainingScreenProvider extends ChangeNotifier {
  /* DATA SECTION */
  // Internal State
  List<MuscleData> _allMuscles = [];
  List<ExerciseData> _allExercises = [];
  List<ExerciseData> _filteredExercises = [];
  List<SessionData> _allLastSessions = [];
  Map<String, DateTime> _lastTrainingTimes = {};
  Map<String, DateTime> _lastMuscleTrainingTimes = {};

  // Currently selected data
  MuscleData? _selectedMuscle;
  ExerciseData? _selectedExercise;
  SessionInfoSchema? _lastSessionSummary;

  // Tiles
  List<MuscleTileSchema> _muscleTiles = [];
  List<ExerciseTileSchema> _exerciseTiles = [];

  TrainingScreenProvider(
    List<MuscleData> allMuscles,
    List<ExerciseData> allExercises,
    List<SessionData> allLastSessions,
  ) {
    _setInitialData(allMuscles, allExercises, allLastSessions);
  }

  void _setInitialData(
    List<MuscleData> allMuscles,
    List<ExerciseData> allExercises,
    List<SessionData> allLastSessions,
  ) {
    _allMuscles = allMuscles;
    _allExercises = allExercises;
    _allLastSessions = allLastSessions;
    _initializeLastTrainingTimes(_allLastSessions);
    _updateTiles();
  }

  // Initializers
  void _initializeLastTrainingTimes(List<SessionData> sessions) {
    for (var session in sessions) {
      _lastTrainingTimes[session.exerciseId] = session.timeStamp;
      
      if (_lastMuscleTrainingTimes.containsKey(session.muscleId)) {
        if (_lastMuscleTrainingTimes[session.muscleId]!.isBefore(session.timeStamp)) {
          _lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
        }
      } else {
        _lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
      }
    }
  }

  void _updateTiles() {
    _muscleTiles = TrainingDataTransformer.transformMusclesToTiles(_allMuscles, _lastMuscleTrainingTimes);
    _exerciseTiles = TrainingDataTransformer.transformExercisesToTiles(_filteredExercises, _lastTrainingTimes);
    notifyListeners();
  }

  // GETTERS
  MuscleData? get selectedMuscle => _selectedMuscle;
  ExerciseData? get selectedExercise => _selectedExercise;
  SessionInfoSchema? get lastSessionSummary => _lastSessionSummary;
  List<MuscleTileSchema> get muscleTiles => _muscleTiles;
  List<ExerciseTileSchema> get exerciseTiles => _exerciseTiles;

  // SETTERS
  void selectMuscleById(String muscleId) {
    try {
      _selectedMuscle = _allMuscles.firstWhere((m) => m.id == muscleId);
    } catch (e) {
      _selectedMuscle = null;
    }

    if (_selectedMuscle != null) {
      _filteredExercises = _allExercises
          .where((e) => e.muscleId == _selectedMuscle!.id)
          .toList();
    } else {
      _filteredExercises = []; // Clear exercises if no muscle matches
    }
    _updateTiles();
  }

  void selectExerciseById(String exerciseId) {
    try {
      _selectedExercise = _allExercises.firstWhere((e) => e.id == exerciseId);
    } catch (e) {
      _selectedExercise = null;
    }

    if (_selectedExercise == null) {
      _lastSessionSummary = null;
    } else {
      try {
        var lastSession = _allLastSessions.firstWhere((s) => s.exerciseId == exerciseId);
        _lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(
        lastSession,
        _selectedExercise!.name,
        _selectedMuscle!.name,
      );
      } catch(e){
        _lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(null, "","");
      }
      
    }

    notifyListeners();
  }

  void setMuscles(List<MuscleData> muscles) {
    _allMuscles = muscles;
    _updateTiles();
  }

  void setExercises(List<ExerciseData> exercises) {
    _allExercises = exercises;
    _updateTiles();
  }

  void setLastSessions(List<SessionData> sessions) {
    _allLastSessions = sessions;
    _initializeLastTrainingTimes(sessions);
    _updateTiles();
  }

  /* PAGE SECTION */
  // Internal State
  int _currentStage = 0;

  // Getters
  int get currentStage => _currentStage;

  // Setters
  void nextStage() {
    _currentStage++;
    notifyListeners();
  }

  void previousStage() {
    if (_currentStage > 0) {
      _currentStage--;
      notifyListeners();
    }
  }

  void resetStage() {
    _currentStage = 0;
    notifyListeners();
  }

  void setStage(int stage, {bool reset = false}) {
    if (reset) {
      _currentStage = 0;
    } else {
      _currentStage = stage;
    }
    notifyListeners();
  }
}
