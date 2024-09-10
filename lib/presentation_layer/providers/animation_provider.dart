import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationProvider = StateNotifierProvider<AnimationControllerNotifier, List<VoidCallback>>(
  (ref) => AnimationControllerNotifier(),
);

class AnimationControllerNotifier extends StateNotifier<List<VoidCallback>> {
  AnimationControllerNotifier() : super([]);

  void addExitCallback(VoidCallback callback) {
    state = [...state, callback];
  }

  void clearCallbacks() {
    state = [];
  }

  void runExitAnimations() {
    for (var callback in state) {
      callback();
    }
    clearCallbacks();
  }
}
