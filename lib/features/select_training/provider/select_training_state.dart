// lib/features/create_training/presentation/create_training_state.dart

import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

class SelectTrainingState {
  final bool isLoading;
  final String? errorMessage;

  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;

  final List<MuscleTileSchema> muscleTiles;
  final List<ExerciseTileSchema> exerciseTiles;

  // Example of selected items
  final MuscleEntity? selectedMuscle;
  final ExerciseEntity? selectedExercise;

  // Add any additional fields you need (e.g., newSession, lastSessions, etc.)

  const SelectTrainingState({
    this.isLoading = false,
    this.errorMessage,
    this.allMuscles = const [],
    this.allExercises = const [],
    this.muscleTiles = const [],
    this.exerciseTiles = const [],
    this.selectedMuscle,
    this.selectedExercise,
  });

  SelectTrainingState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<MuscleTileSchema>? muscleTiles,
    List<ExerciseTileSchema>? exerciseTiles,
    MuscleEntity? selectedMuscle,
    ExerciseEntity? selectedExercise,
  }) {
    return SelectTrainingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      muscleTiles: muscleTiles ?? this.muscleTiles,
      exerciseTiles: exerciseTiles ?? this.exerciseTiles,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
    );
  }
}
