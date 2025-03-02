// lib/features/process_training/provider/process_training_state.dart

import 'package:gymini/domain_layer/entities/core_entities.dart';

class ProcessTrainingState {
  final SessionEntity? session;
  final String? selectedExerciseId;
  final String? selectedMuscleId;
  final int currentStage;
  final bool isLoading;
  final String? errorMessage;

  ProcessTrainingState({
    this.session,
    this.selectedExerciseId,
    this.selectedMuscleId,
    this.currentStage = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  ProcessTrainingState copyWith({
    SessionEntity? session,
    String? selectedExerciseId,
    String? selectedMuscleId,
    int? currentStage,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProcessTrainingState(
      session: session ?? this.session,
      selectedExerciseId: selectedExerciseId ?? this.selectedExerciseId,
      selectedMuscleId: selectedMuscleId ?? this.selectedMuscleId,
      currentStage: currentStage ?? this.currentStage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  static ProcessTrainingState initial() => ProcessTrainingState();
}
