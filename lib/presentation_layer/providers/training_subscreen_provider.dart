import 'package:flutter/material.dart';

class TrainingSubScreenProvider with ChangeNotifier {
int _currentStage = 1;

  int get currentStage => _currentStage;

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