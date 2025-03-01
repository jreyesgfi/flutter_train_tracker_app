// lib/common/shared_data/training_data_transformer.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/session_info.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

final trainingDataTransformer = Provider<TrainingDataTransformer>((ref) {
  return TrainingDataTransformer();
});

/// A singleton transformer that converts domain entities into tile schemas,
/// automatically obtaining liked status and last training times from the repositories.
class TrainingDataTransformer {
  // Private constructor for singleton.
  TrainingDataTransformer._internal();
  static final TrainingDataTransformer _instance =
      TrainingDataTransformer._internal();
  factory TrainingDataTransformer() => _instance;

  /// Transform a single muscle into a MuscleTileSchema by obtaining its liked status
  /// and last training time from the [localRepository] and [sessionRepository].
  Future<MuscleTileSchema> transformMuscleToTile({
    required MuscleEntity muscle,
    required LocalRepository localRepository,
    required SessionRepository sessionRepository,
  }) async {
    final likedMuscles = await localRepository.getLikedMuscles();
    final bool liked = likedMuscles.contains(muscle.id);

    final lastSession = await sessionRepository.fetchLastSessionByMuscleId(muscle.id);
    final DateTime? lastTrainingTime = lastSession?.timeStamp;

    return MuscleTileSchema(
      muscleId: muscle.id,
      label: muscle.name,
      timeSinceExercise: calculateDaysSinceLastExercise(lastTrainingTime),
      imagePath: muscleImagePath(muscle),
      liked: liked,
    );
  }

  /// Transform a list of muscles into a sorted list of MuscleTileSchema.
  Future<List<MuscleTileSchema>> transformMusclesToTiles({
    required List<MuscleEntity> muscles,
    required LocalRepository localRepository,
    required SessionRepository sessionRepository,
  }) async {
    final List<MuscleTileSchema> tiles = [];
    for (var muscle in muscles) {
      final tile = await transformMuscleToTile(
        muscle: muscle,
        localRepository: localRepository,
        sessionRepository: sessionRepository,
      );
      tiles.add(tile);
    }
    tiles.sort((a, b) => b.timeSinceExercise.compareTo(a.timeSinceExercise));
    return tiles;
  }

  /// Transform a single exercise into an ExerciseTileSchema by obtaining its liked status
  /// and last training time from the [localRepository] and [sessionRepository].
  Future<ExerciseTileSchema> transformExerciseToTile({
    required ExerciseEntity exercise,
    required LocalRepository localRepository,
    required SessionRepository sessionRepository,
  }) async {
    final likedExercises = await localRepository.getLikedExercises();
    final bool liked = likedExercises.contains(exercise.id);

    final lastSession = await sessionRepository.fetchLastSessionByExerciseId(exercise.id);
    final DateTime? lastTrainingTime = lastSession?.timeStamp;

    return ExerciseTileSchema(
      exerciseId: exercise.id,
      label: exercise.name,
      imagePath: exerciseImagePaths(exercise)[0],
      liked: liked,
      timeSinceExercise: calculateDaysSinceLastExercise(lastTrainingTime),
    );
  }

  /// Transform a list of exercises into a sorted list of ExerciseTileSchema.
  Future<List<ExerciseTileSchema>> transformExercisesToTiles({
    required List<ExerciseEntity> exercises,
    required LocalRepository localRepository,
    required SessionRepository sessionRepository,
  }) async {
    final List<ExerciseTileSchema> tiles = [];
    for (var exercise in exercises) {
      final tile = await transformExerciseToTile(
        exercise: exercise,
        localRepository: localRepository,
        sessionRepository: sessionRepository,
      );
      tiles.add(tile);
    }
    tiles.sort((a, b) {
      final timeComparison = a.timeSinceExercise.compareTo(b.timeSinceExercise);
      if (timeComparison != 0) return timeComparison;
      return a.label.compareTo(b.label);
    });
    return tiles;
  }

  /// Transform a session into a summary.
  SessionInfoSchema transformSessionToSummary(
      SessionEntity? session, String exerciseName, String muscleName) {
    if (session == null) {
      return SessionInfoSchema(
        exerciseName: '',
        muscleGroup: '',
        timeSinceLastSession: 0,
        maxReps: 0,
        minReps: 0,
        maxWeight: 0,
        minWeight: 0,
      );
    }
    return SessionInfoSchema(
      exerciseName: exerciseName,
      muscleGroup: muscleName,
      timeSinceLastSession: calculateDaysSinceLastExercise(session.timeStamp),
      maxReps: session.maxReps,
      minReps: session.minReps,
      maxWeight: session.maxWeight,
      minWeight: session.minWeight,
    );
  }

  /// Calculate days since the last exercise.
  static int calculateDaysSinceLastExercise(DateTime? lastExerciseDate) {
    return lastExerciseDate != null
        ? DateTime.now().difference(lastExerciseDate).inDays
        : 365;
  }

  /// Determine the image path for a muscle.
  static String muscleImagePath(MuscleEntity muscle) {
    return "assets/images/test/muscles/${muscle.id}.svg";
  }

  /// Determine the image paths for an exercise.
  static List<String> exerciseImagePaths(ExerciseEntity exercise) {
    final commonPath = "assets/images/exercises/${exercise.id}";
    return ["$commonPath.webp", "${commonPath}2.png"];
  }
}
