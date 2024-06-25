import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';

class TrainingDataTransformer {
  static List<MuscleTileSchema> transformMusclesToTiles(List<MuscleData> muscles) {
    return muscles.map((muscle) => MuscleTileSchema(
      muscleId: muscle.id,
      label: muscle.name,
      timeSinceExercise: calculateDaysSinceLastExercise(muscle.id), // This needs to be implemented
      imagePath: "assets/images/test/muscles/${muscle.id}.svg", // Example path
    )).toList();
  }

  static List<ExerciseTileSchema> transformExercisesToTiles(List<ExerciseData> exercises) {
    return exercises.map((exercise) => ExerciseTileSchema(
      exerciseId: exercise.id,
      label: exercise.name,                     //assets\images\test\exercises\m1\e1_1.png
      imagePath: "assets/images/test/exercises/${exercise.muscleId}/${exercise.id}_1.png", // Example path
      timeSinceExercise: calculateDaysSinceLastExercise(exercise.id), // This needs to be implemented
    )).toList();
  }

  // Placeholder for actual logic to determine days since last exercise
  static int calculateDaysSinceLastExercise(String id) {
    return DateTime.now().difference(DateTime.now().subtract(Duration(days: 5))).inDays; // Mock example
  }
}
