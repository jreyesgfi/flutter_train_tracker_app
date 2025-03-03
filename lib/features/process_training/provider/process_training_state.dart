import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';

class ProcessTrainingState {
  final SessionEntity session;
  final SessionTile sessionTile;
  final String? selectedExerciseId;
  final String? selectedMuscleId;
  final int currentStage;
  final bool isLoading;
  final String? errorMessage;

  ProcessTrainingState({
    required this.session,
    required this.sessionTile,
    this.selectedExerciseId,
    this.selectedMuscleId,
    this.currentStage = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  ProcessTrainingState copyWith({
    SessionEntity? session,
    SessionTile? sessionTile,
    String? selectedExerciseId,
    String? selectedMuscleId,
    int? currentStage,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProcessTrainingState(
      session: session ?? this.session,
      sessionTile: sessionTile ?? this.sessionTile,
      selectedExerciseId: selectedExerciseId ?? this.selectedExerciseId,
      selectedMuscleId: selectedMuscleId ?? this.selectedMuscleId,
      currentStage: currentStage ?? this.currentStage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  static ProcessTrainingState initial() => ProcessTrainingState(
        session: SessionEntity(
          id: '',
          exerciseId: '',
          muscleId: '',
          timeStamp: DateTime.now(),
          maxWeight: 0,
          minWeight: 0,
          maxReps: 0,
          minReps: 0,
        ),
        sessionTile: SessionTile(
          exerciseName: '',
          pathImages: [],
          muscleGroup: '',
          timeSinceLastSession: 0,
          minWeight: 0,
          maxWeight: 0,
          minReps: 0,
          maxReps: 0,
        ),
      );
}
