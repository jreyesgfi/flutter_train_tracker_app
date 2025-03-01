// lib/features/create_training/presentation/create_training_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final LocalRepository localRepository;

  CreateTrainingNotifier({
    required this.sessionRepository,
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.localRepository,
  }) : super(const CreateTrainingState()) {
    _init();
  }

  /// Fetch all the data required for the create training screen
  Future<void> _init() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 1. Fetch domain data from each repository
      final muscles = await muscleRepository.fetchAllMuscles();
      final exercises = await exerciseRepository.fetchAllExercises();

      // Populate session repository's in-memory cache
      await sessionRepository.fetchAllSessions();

      // 2. Fetch local liked items
      final likedMuscles = await localRepository.getLikedMuscles();
      final likedExercises = await localRepository.getLikedExercises();

      // 3. Transform domain data into tile schemas.
      // For demonstration, lastTrainingTime is left as null.
      final List<MuscleTileSchema> muscleTiles = muscles.map((muscle) {
        DateTime? lastTrainingTime = null;
        return TrainingDataTransformer.transformMuscleToTile(
          muscle,
          lastTrainingTime,
          likedMuscles,
        );
      }).toList();

      final List<ExerciseTileSchema> exerciseTiles = exercises.map((exercise) {
        DateTime? lastTrainingTime = null;
        return TrainingDataTransformer.transformExerciseToTile(
          exercise,
          lastTrainingTime,
          likedExercises,
        );
      }).toList();

      // 4. Update state with the fetched + transformed data
      state = state.copyWith(
        isLoading: false,
        allMuscles: muscles,
        allExercises: exercises,
        muscleTiles: muscleTiles,
        exerciseTiles: exerciseTiles,
      );
    } catch (e, stack) {
      // Handle any errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Handle muscle selection by filtering related exercises and updating tiles.
  void selectMuscle(MuscleEntity muscle) {
    final filteredExercises = state.allExercises
        .where((e) => e.muscleId == muscle.id)
        .toList();

    final List<ExerciseTileSchema> newExerciseTiles = filteredExercises.map((exercise) {
      DateTime? lastTrainingTime = null;
      return TrainingDataTransformer.transformExerciseToTile(
        exercise,
        lastTrainingTime,
        [], // Optionally pass liked exercises if needed
      );
    }).toList();

    state = state.copyWith(
      selectedMuscle: muscle,
      exerciseTiles: newExerciseTiles,
    );
  }

  /// Handle exercise selection.
  void selectExercise(ExerciseEntity exercise) {
    state = state.copyWith(selectedExercise: exercise);
  }

  /// Toggle the "like" state for a muscle.
  Future<void> toggleMuscleLikeState(String muscleId) async {
    await localRepository.toggleMuscleLikeState(muscleId);
    final likedMuscles = await localRepository.getLikedMuscles();

    final List<MuscleTileSchema> updatedMuscleTiles = state.allMuscles.map((muscle) {
      DateTime? lastTrainingTime = null;
      return TrainingDataTransformer.transformMuscleToTile(
        muscle,
        lastTrainingTime,
        likedMuscles,
      );
    }).toList();

    state = state.copyWith(muscleTiles: updatedMuscleTiles);
  }

  /// Toggle the "like" state for an exercise.
  Future<void> toggleExerciseLikeState(String exerciseId) async {
    await localRepository.toggleExerciseLikeState(exerciseId);
    final likedExercises = await localRepository.getLikedExercises();

    final List<ExerciseTileSchema> updatedExerciseTiles = state.allExercises.map((exercise) {
      DateTime? lastTrainingTime = null;
      return TrainingDataTransformer.transformExerciseToTile(
        exercise,
        lastTrainingTime,
        likedExercises,
      );
    }).toList();

    state = state.copyWith(exerciseTiles: updatedExerciseTiles);
  }
}
