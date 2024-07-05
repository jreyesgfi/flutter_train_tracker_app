import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';

class ReportScreenProvider extends ChangeNotifier {
  /* DATA SECTION */
  // Internal State
  List<MuscleData> _allMuscles = [];
  List<ExerciseData> _allExercises = [];
  List<SessionData> _filteredSessions = [];

  // Currently selected data
  MuscleData? _selectedMuscle;
  ExerciseData? _selectedExercise;

  final MockDataRepository _repository = MockDataRepository();

  ReportScreenProvider(
    List<MuscleData> allMuscles,
    List<ExerciseData> allExercises,
  ) {
    _setData(allMuscles, allExercises);
    filterSessions();
  }

  void _setData(
    List<MuscleData> allMuscles,
    List<ExerciseData> allExercises,
  ) {
    _allMuscles = allMuscles;
    _allExercises = allExercises;
  }

  List<MuscleData> get allMuscles => _allMuscles;
  List<ExerciseData> get allExercises => _allExercises;
  List<SessionData> get filteredSessions => _filteredSessions;

  MuscleData? get selectedMuscle => _selectedMuscle;
  ExerciseData? get selectedExercise => _selectedExercise;

  void selectMuscleById(String? muscleId) {
    try {
      _selectedMuscle = _allMuscles.firstWhere((e) => e.id == muscleId);
    } catch (e) {
      _selectedMuscle = null;
    }
    notifyListeners();
  }

  void selectExerciseById(String exerciseId) {
    try {
      _selectedExercise = _allExercises.firstWhere((e) => e.id == exerciseId);
    } catch (e) {
      _selectedExercise = null;
    }
    notifyListeners();
  }

  void filterSessions() async {
    String? muscleId = _selectedMuscle?.id;
    String? exerciseId = _selectedExercise?.id;

    _filteredSessions = await _repository.fetchFilteredSessions(muscleId: muscleId, exerciseId: exerciseId);
    notifyListeners();
  }
}
