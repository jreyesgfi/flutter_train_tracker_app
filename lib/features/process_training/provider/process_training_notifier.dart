// lib/features/process_training/provider/process_training_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/global_stream.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/process_training/provider/process_training_state.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:uuid/uuid.dart';

/// A simple class representing UI input values for a session.
class SessionValues {
  final double maxWeight;
  final double minWeight;
  final int maxReps;
  final int minReps;

  SessionValues({
    required this.maxWeight,
    required this.minWeight,
    required this.maxReps,
    required this.minReps,
  });
}

class ProcessTrainingNotifier extends StateNotifier<ProcessTrainingState> {
  final SessionRepository sessionRepository;
  final LocalRepository localRepository;
  final GlobalSharedStreams sharedStreams;

  ProcessTrainingNotifier({
    required this.sessionRepository,
    required this.localRepository,
    required this.sharedStreams,
  }) : super(ProcessTrainingState.initial());

  /// Update the session values from UI input.
  void updateSessionValues(SessionValues sessionValues) {
    // Ensure that selectedExerciseId and selectedMuscleId are already set.
    if (state.selectedExerciseId == null || state.selectedMuscleId == null) {
      // You might handle this error.
      return;
    }
    final newSession = SessionEntity(
      id: state.session?.id ?? const Uuid().v4(),
      exerciseId: state.selectedExerciseId!,
      muscleId: state.selectedMuscleId!,
      timeStamp: DateTime.now(),
      maxWeight: sessionValues.maxWeight,
      minWeight: sessionValues.minWeight,
      maxReps: sessionValues.maxReps,
      minReps: sessionValues.minReps,
    );
    state = state.copyWith(session: newSession);
  }

  /// Commit (save) the session to the repository and then clear the shared selection.
  Future<void> commitSession() async {
    if (state.session == null) return;
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await sessionRepository.createNewSession(state.session!);
      
      // Clear the shared selected exercise signal so the router will go back to selection.
      sharedStreams.selectedExerciseIdStream.update(null);
      
      // Reset the state for process_training.
      state = ProcessTrainingState.initial();
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }
}
