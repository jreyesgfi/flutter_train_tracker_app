// lib/features/process_training/provider/process_training_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/shared_preferences/chrono_storage.dart';
import 'package:gymini/common/shared_data/streams/global_stream.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';
import 'package:gymini/features/process_training/provider/process_training_state.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:gymini/features/process_training/adapter/session_data_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// A simple class representing UI input for the session form.
class ProcessTrainingNotifier extends StateNotifier<ProcessTrainingState> {
  final SessionRepository sessionRepository;
  final LocalRepository localRepository;
  final GlobalSharedStreams sharedStreams;
  final SessionDataAdapter adapter = SessionDataAdapter();

  ProcessTrainingNotifier({
    required this.sessionRepository,
    required this.localRepository,
    required this.sharedStreams,
  }) : super(ProcessTrainingState.initial()) {
    createSessionEntity();
    _suscribeToStreams();
  }

  void _suscribeToStreams() {
    // Listen for changes to the selected muscle.
    sharedStreams.selectedExerciseStream.stream.listen((exercise) async {
      createSessionEntity();
    });
  }

  // Create an entity based on the selected exercise and muscle.
  void createSessionEntity() async {
    ExerciseEntity? exercise = sharedStreams.selectedExerciseStream.latestValue;
    MuscleEntity? muscle = sharedStreams.selectedMuscleStream.latestValue;
    // Optionally load an existing session if selections exist.
    if (exercise != null && muscle != null) {
      final lastSession =
          await sessionRepository.fetchLastSessionByExerciseId(exercise.id);
      if (lastSession != null) {
        final tile = adapter.transformSessionToTile(
          lastSession,
          exercise: exercise,
          muscle: muscle,
        );
        state = state.copyWith(session: lastSession, sessionTile: tile);
      }
    }
  }

  /// Update the session values based on UI input.
  void updateSessionValues(SessionFormTile sessionValues) {
    ExerciseEntity? exercise = sharedStreams.selectedExerciseStream.latestValue;
    MuscleEntity? muscle = sharedStreams.selectedMuscleStream.latestValue;
    if (exercise == null || muscle == null) return;
    final newSession = SessionEntity(
      id: state.session.id.isEmpty ? const Uuid().v4() : state.session.id,
      exerciseId: exercise.id,
      muscleId: muscle.id,
      timeStamp: DateTime.now(),
      maxWeight: sessionValues.maxWeight,
      minWeight: sessionValues.minWeight,
      maxReps: sessionValues.maxReps,
      minReps: sessionValues.minReps,
    );
    final tile = adapter.transformSessionToTile(
      newSession,
      exercise: exercise,
      muscle: muscle,
    );
    state = state.copyWith(session: newSession, sessionTile: tile);
  }

  /// Commit (save) the session and clear shared signals.
  Future<void> commitSession() async {
    // Check by session id (if empty, no valid session).
    print("Commit session: ${state.session.id}");
    if (state.session.id.isEmpty) return;
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await sessionRepository.createNewSession(state.session);
      // Clear shared signals so that the router falls back to the selection screen.
      resetStage();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Set the selected exercise and muscle IDs.
  /// (In a more advanced version you might pass full objects instead.)
  void setSelection({required String exerciseId, required String muscleId}) {
    state = state.copyWith(
      selectedExerciseId: exerciseId,
      selectedMuscleId: muscleId,
    );
  }

  /// Navigate between stages.
  void nextStage() {
    state = state.copyWith(currentStage: state.currentStage + 1);
  }

  void previousStage() {
    if (state.currentStage > 0) {
      state = state.copyWith(currentStage: state.currentStage - 1);
    }
  }

  void resetStage() async{
    sharedStreams.selectedExerciseStream.update(null);
    ChronoStorage.deleteAllChronoStartTimes();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_stage', 0);
    state = ProcessTrainingState.initial();
  }
}
