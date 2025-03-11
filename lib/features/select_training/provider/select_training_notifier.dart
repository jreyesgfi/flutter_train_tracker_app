// lib/features/create_training/presentation/create_training_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/streams/global_stream.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/select_training/provider/select_training_state.dart';
import 'package:gymini/features/select_training/adapter/training_data_adapter.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

class SelectTrainingNotifier extends StateNotifier<SelectTrainingState> {
  final SessionRepository sessionRepository;
  final MuscleRepository muscleRepository;
  final ExerciseRepository exerciseRepository;
  final TrainingDataAdapter dataTransformer;
  final LocalRepository localRepository;
  final GlobalSharedStreams sharedStreams;

  SelectTrainingNotifier({
    required this.sessionRepository,
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.dataTransformer,
    required this.localRepository,
    required this.sharedStreams,
  }) : super(const SelectTrainingState()) {
    _init();
    _suscribeToStreams();
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
      final List<MuscleTileSchema> muscleTiles =
          await dataTransformer.transformMusclesToTiles(
              muscles: muscles,
              localRepository: localRepository,
              sessionRepository: sessionRepository);

      // 3. Update state with the fetched and transformed data.
      state = state.copyWith(
        isLoading: false,
        allMuscles: muscles,
        allExercises: exercises,
        muscleTiles: muscleTiles,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _suscribeToStreams() {
    // Listen for changes to the selected muscle.
    sharedStreams.selectedMuscleStream.stream.listen((muscle) async {
      // Filter exercises if a muscle is selected, or use all if not.
      final List<ExerciseEntity> filteredExercises = muscle == null
          ? []
          : state.allExercises.where((e) => e.muscleId == muscle.id).toList();
          

      final List<ExerciseTileSchema> newExerciseTiles =
          await dataTransformer.transformExercisesToTiles(
        exercises: filteredExercises,
        localRepository: localRepository,
        sessionRepository: sessionRepository,
      );

      // Update state with the new exercise tiles.
      state = state.copyWith(exerciseTiles: newExerciseTiles);
    });
  }

  // /// Handle muscle selection by filtering related exercises and updating tiles.
  // void selectMuscle(MuscleEntity muscle) async{
  //   final List<ExerciseEntity> filteredExercises = state.allExercises.where((e) => e.muscleId == muscle.id).toList();

  //   final List<ExerciseTileSchema> newExerciseTiles = await dataTransformer.transformExercisesToTiles(exercises: filteredExercises, localRepository: localRepository, sessionRepository: sessionRepository);

  //   state = state.copyWith(
  //     selectedMuscle: muscle,
  //     exerciseTiles: newExerciseTiles,
  //   );
  //   // Broadcast the selected muscle ID.
  //   sharedStreams.selectedMuscleStream.update(muscle);
  // }

  // /// Handle exercise selection.
  // void selectExercise(ExerciseEntity exercise) {
  //   state = state.copyWith(selectedExercise: exercise);
  //   // Broadcast the selected exercise ID.
  //   sharedStreams.selectedExerciseStream.update(exercise);
  // }

  void selectMuscle(MuscleEntity muscle) {
    sharedStreams.selectedMuscleStream.update(muscle);
  }

  void selectExercise(ExerciseEntity exercise) {
    sharedStreams.selectedExerciseStream.update(exercise);
  }

  /// Toggle the "like" state for a muscle.
  Future<void> toggleMuscleLikeState(String muscleId) async {
    await localRepository.toggleMuscleLikeState(muscleId);
    final List<MuscleTileSchema> updatedMuscleTiles =
        await dataTransformer.transformMusclesToTiles(
            muscles: state.allMuscles,
            localRepository: localRepository,
            sessionRepository: sessionRepository);
    state = state.copyWith(muscleTiles: updatedMuscleTiles);
  }

  /// Toggle the "like" state for an exercise.
  Future<void> toggleExerciseLikeState(String exerciseId) async {
    await localRepository.toggleExerciseLikeState(exerciseId);
    final List<ExerciseTileSchema> updatedExerciseTiles =
        await dataTransformer.transformExercisesToTiles(
            exercises: state.allExercises,
            localRepository: localRepository,
            sessionRepository: sessionRepository);
    state = state.copyWith(exerciseTiles: updatedExerciseTiles);
  }
}
