import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/session_info.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';

abstract class TrainingDataTransformer {
  static MuscleTileSchema transformMuscleToTile(
    MuscleEntity muscle,
    DateTime? lastTrainingTime,
    List<String> likedMuscleIds,
  ) {
    return MuscleTileSchema(
      muscleId: muscle.id,
      label: muscle.name,
      timeSinceExercise: calculateDaysSinceLastExercise(lastTrainingTime),
      imagePath: muscleImagePath(muscle),
      liked: likedMuscleIds.contains(muscle.id),
    );
  }

  // static List<MuscleTileSchema> transformMusclesToTiles(
  //   List<MuscleEntity> muscles,
  //   Map<String, DateTime> lastTrainingTimes,
  //   List<String> likedMuscleIds,
  // ) {
  //   final tiles = muscles
  //       .map((muscle) => transformMuscleToTile(muscle, lastTrainingTimes[muscle.id], likedMuscleIds))
  //       .toList();
  //   tiles.sort((a, b) => b.timeSinceExercise.compareTo(a.timeSinceExercise));
  //   return tiles;
  // }

  static ExerciseTileSchema transformExerciseToTile(
    ExerciseEntity exercise,
    DateTime? lastTrainingTime,
    List<String> likedExercisesIds,
  ) {
    return ExerciseTileSchema(
      exerciseId: exercise.id,
      label: exercise.name,
      imagePath: exerciseImagePaths(exercise)[0],
      liked: likedExercisesIds.contains(exercise.id),
      timeSinceExercise: calculateDaysSinceLastExercise(lastTrainingTime),
    );
  }

  // static List<ExerciseTileSchema> transformExercisesToTiles(
  //     List<ExerciseEntity> exercises,
  //     Map<String,
  //     DateTime> lastTrainingTimes,
  //     List<String> likedExercisesIds,
  //   ) {
  //   final tiles = exercises
  //       .map((exercise) => transformExerciseToTile(exercise, lastTrainingTimes[exercise.id], likedExercisesIds))
  //       .toList();

  //   tiles.sort((a, b) {
  //     // First compare by timeSinceExercise
  //     final timeComparison = a.timeSinceExercise.compareTo(b.timeSinceExercise);
  //     // If timeSinceExercise is the same, compare by label
  //     if (timeComparison != 0) {
  //       return timeComparison;
  //     } else {
  //       return a.label.compareTo(b.label);
  //     }
  //   });

  //   return tiles;
  // }

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
    return lastExerciseDate != null
        ? DateTime.now().difference(lastExerciseDate).inDays
        : 365;
  }

  static List<String> exerciseImagePaths(ExerciseEntity exercise) {
    final commonPath = "assets/images/exercises/${exercise.id}";
    return ["$commonPath.webp", "${commonPath}2.png"];
  }

  static String muscleImagePath(MuscleEntity muscle) {
    return "assets/images/test/muscles/${muscle.id}.svg";
  }
}
