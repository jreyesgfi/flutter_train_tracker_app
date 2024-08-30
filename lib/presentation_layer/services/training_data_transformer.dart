import 'package:collection/collection.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';

class TrainingDataTransformer {
  static List<MuscleTileSchema> transformMusclesToTiles(
      List<MuscleEntity> muscles,
      Map<String, DateTime> lastTrainingTimes,
      List<String> likedMuscleIds,
    ) {
    final tiles = muscles
        .map((muscle) => MuscleTileSchema(
              muscleId: muscle.id,
              label: muscle.name,
              timeSinceExercise:
                  calculateDaysSinceLastExercise(lastTrainingTimes[muscle.id]),
              imagePath: muscleImagePath(muscle),
              liked: likedMuscleIds.contains(muscle.id)
            ))
        .toList();
    tiles.sort((a,b) => b.timeSinceExercise.compareTo(a.timeSinceExercise));
    return tiles;
  }

  static List<ExerciseTileSchema> transformExercisesToTiles(
    List<ExerciseEntity> exercises, Map<String, DateTime> lastTrainingTimes) {
    final tiles = exercises
        .map((exercise) => ExerciseTileSchema(
              exerciseId: exercise.id,
              label: exercise.name,
              imagePath: exerciseImagePaths(exercise)[0],
              timeSinceExercise: calculateDaysSinceLastExercise(
                  lastTrainingTimes[exercise.id]),
            ))
        .toList();
    tiles.sort((a,b) => b.timeSinceExercise.compareTo(a.timeSinceExercise));
    return tiles;
  }

  static SessionInfoSchema transformSessionToSummary(
      SessionEntity? session, exerciseName, muscleName) {
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

  // Placeholder for actual logic to determine days since last exercise
  static int calculateDaysSinceLastExercise(DateTime? lastExerciseDate) {
    return lastExerciseDate != null ? 
      DateTime.now().difference(lastExerciseDate).inDays
      : 365;
  }
  static List<String> exerciseImagePaths(ExerciseEntity exercise) {
    final commonPath = "assets/images/test/exercises/${exercise.muscleId}/${exercise.id}_";
    return 
    ["${commonPath}1.png",
    "${commonPath}2.png"];
  }
  static String muscleImagePath(MuscleEntity muscle) {
    return "assets/images/test/muscles/${muscle.id}.svg";
  }
}
