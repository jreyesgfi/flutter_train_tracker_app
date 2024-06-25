import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

class TrainingScreenProvider extends ChangeNotifier {
  
  // INTERNAL STATE
  int _currentStage = 0;
  MuscleData? _selectedMuscle;
  ExerciseData? _selectedExercise;

  List<MuscleData> _allMuscles = [];
  List<ExerciseData> _allExercises = [];
  List<ExerciseData> _filteredExercises = [];

  TrainingScreenProvider(this._allMuscles, this._allExercises);

  // GETTERS
  int get currentStage => _currentStage;
  MuscleData? get selectedMuscle => _selectedMuscle;
  ExerciseData? get selectedExercise => _selectedExercise;
  List<MuscleData> get allMuscles => _allMuscles;
  List<ExerciseData> get filteredExercises => _filteredExercises;


  // SETTERS
  void setCurrentStage(int stage) {
    _currentStage = stage;
    notifyListeners();
  }

  void selectMuscle(MuscleData muscle) {
    _selectedMuscle = muscle;
    _filteredExercises = _allExercises.where((e) => e.muscleId == muscle.id).toList();
    notifyListeners();
  }

  void selectExercise(ExerciseData exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }

  void setMuscles(List<MuscleData> muscles) {
    _allMuscles = muscles;
    notifyListeners();
  }

  void setExercises(List<ExerciseData> exercises) {
    _allExercises = exercises;
    notifyListeners();
  }
}
