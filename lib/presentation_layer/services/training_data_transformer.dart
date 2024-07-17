import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';

class TrainingDataTransformer {
  static List<MuscleTileSchema> transformMusclesToTiles(
      List<MuscleData> muscles, Map<String, DateTime> lastTrainingTimes) {
    return muscles
        .map((muscle) => MuscleTileSchema(
              muscleId: muscle.id,
              label: muscle.name,
              timeSinceExercise:
                  calculateDaysSinceLastExercise(lastTrainingTimes[muscle.id]),
              imagePath: muscleImagePath(muscle),
            ))
        .toList();
  }

  static List<ExerciseTileSchema> transformExercisesToTiles(
      List<ExerciseData> exercises, Map<String, DateTime> lastTrainingTimes) {
    return exercises
        .map((exercise) => ExerciseTileSchema(
              exerciseId: exercise.id,
              label: exercise.name,
              imagePath: exerciseImagePaths(exercise)[0],
              timeSinceExercise: calculateDaysSinceLastExercise(
                  lastTrainingTimes[exercise.id]),
            ))
        .toList();
  }

  static SessionInfoSchema transformSessionToSummary(
      SessionData? session, exerciseName, muscleName) {
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
    return DateTime.now().difference(lastExerciseDate ?? DateTime.now()).inDays;
  }
  static List<String> exerciseImagePaths(ExerciseData exercise) {
    final commonPath = "assets/images/test/exercises/${exercise.muscleId}/${exercise.id}_";
    return 
    ["${commonPath}1.png",
    "${commonPath}2.png"];
  }
  static String muscleImagePath(MuscleData muscle) {
    return "assets/images/test/muscles/${muscle.id}.svg";
  }
}
