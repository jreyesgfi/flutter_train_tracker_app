import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

class TrainingScreenProvider extends ChangeNotifier {
  int _currentStage = 0;
  MuscleData? _selectedMuscle;
  ExerciseData? _selectedExercise;

  int get currentStage => _currentStage;
  MuscleData? get selectedMuscle => _selectedMuscle;
  ExerciseData? get selectedExercise => _selectedExercise;

  void setCurrentStage(int stage) {
    _currentStage = stage;
    notifyListeners();
  }

  void selectMuscle(MuscleData muscle) {
    _selectedMuscle = muscle;
    notifyListeners();
  }

  void selectExercise(ExerciseData exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }
}
