// lib/features/create_training/presentation/create_training_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/global_stream.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/create_training/provider/create_training_state.dart';
import 'package:gymini/presentation_layer/services/training_data_transformer.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

class CreateTrainingNotifier extends StateNotifier<CreateTrainingState> {
  final SessionRepository sessionRepository;
  final MuscleRepository muscleRepository;
  final ExerciseRepository exerciseRepository;
  final TrainingDataTransformer dataTransformer;
  final LocalRepository localRepository;
  final GlobalSharedStreams sharedStreams;

  CreateTrainingNotifier({
    required this.sessionRepository,
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.dataTransformer,
    required this.localRepository,
    required this.sharedStreams,
  }) : super(const CreateTrainingState()) {
    _init();
  }

  /// Fetch all the data required for the create training screen.
  Future<void> _init() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 1. Fetch domain data from each repository.
      final muscles = await muscleRepository.fetchAllMuscles();
      final exercises = await exerciseRepository.fetchAllExercises();

      // Populate session repository's in-memory cache.
      await sessionRepository.fetchAllSessions();

      // 2. Transform domain data into tile schemas.
      // For demonstration, lastTrainingTime is left as null.
      final List<MuscleTileSchema> muscleTiles = await dataTransformer.transformMusclesToTiles(muscles: muscles, localRepository: localRepository, sessionRepository: sessionRepository);

      final List<ExerciseTileSchema> exerciseTiles = await dataTransformer.transformExercisesToTiles(exercises: exercises, localRepository: localRepository, sessionRepository: sessionRepository);

      // 4. Update state with the fetched and transformed data.
      state = state.copyWith(
        isLoading: false,
        allMuscles: muscles,
        allExercises: exercises,
        muscleTiles: muscleTiles,
        exerciseTiles: exerciseTiles,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// When a new session is created in create_training, update the global stream.
  void createNewSession(SessionEntity newSession) {
    // You might also update your local state here if needed.
    sharedStreams.sessionStream.update(newSession);
  }

  /// Handle muscle selection by filtering related exercises and updating tiles.
  void selectMuscle(MuscleEntity muscle) async{
    final List<ExerciseEntity> filteredExercises = state.allExercises.where((e) => e.muscleId == muscle.id).toList();

    final List<ExerciseTileSchema> newExerciseTiles = await dataTransformer.transformExercisesToTiles(exercises: filteredExercises, localRepository: localRepository, sessionRepository: sessionRepository);

    state = state.copyWith(
      selectedMuscle: muscle,
      exerciseTiles: newExerciseTiles,
    );
    // Broadcast the selected muscle ID.
    sharedStreams.selectedMuscleIdStream.update(muscle.id);
  }

  /// Handle exercise selection.
  void selectExercise(ExerciseEntity exercise) {
    state = state.copyWith(selectedExercise: exercise);
    // Broadcast the selected exercise ID.
    sharedStreams.selectedExerciseIdStream.update(exercise.id);
  }

  /// Toggle the "like" state for a muscle.
  Future<void> toggleMuscleLikeState(String muscleId) async {
    await localRepository.toggleMuscleLikeState(muscleId);
    final List<MuscleTileSchema> updatedMuscleTiles = await dataTransformer.transformMusclesToTiles(muscles: state.allMuscles, localRepository: localRepository, sessionRepository: sessionRepository);
    state = state.copyWith(muscleTiles: updatedMuscleTiles);
  }

  /// Toggle the "like" state for an exercise.
  Future<void> toggleExerciseLikeState(String exerciseId) async {
    await localRepository.toggleExerciseLikeState(exerciseId);
    final List<ExerciseTileSchema> updatedExerciseTiles = await dataTransformer.transformExercisesToTiles(exercises: state.allExercises, localRepository: localRepository, sessionRepository: sessionRepository);
    state = state.copyWith(exerciseTiles: updatedExerciseTiles);
  }
}