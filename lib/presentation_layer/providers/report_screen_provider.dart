import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';

class ReportScreenProvider extends ChangeNotifier {
  /* DATA SECTION */
  // Internal State
  List<MuscleEntity> _allMuscles = [];
  List<ExerciseEntity> _allExercises = [];
  List<SessionEntity> _filteredSessions = [];

  // Currently selected data
  MuscleEntity? _selectedMuscle;
  ExerciseEntity? _selectedExercise;

  final MockDataRepository _repository = MockDataRepository();

  ReportScreenProvider(
    List<MuscleEntity> allMuscles,
    List<ExerciseEntity> allExercises,
  ) {
    _setData(allMuscles, allExercises);
    filterSessions();
  }

  void _setData(
    List<MuscleEntity> allMuscles,
    List<ExerciseEntity> allExercises,
  ) {
    _allMuscles = allMuscles;
    _allExercises = allExercises;
  }

  List<MuscleEntity> get allMuscles => _allMuscles;
  List<ExerciseEntity> get allExercises => _allExercises;
  List<SessionEntity> get filteredSessions => _filteredSessions;

  MuscleEntity? get selectedMuscle => _selectedMuscle;
  ExerciseEntity? get selectedExercise => _selectedExercise;

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
