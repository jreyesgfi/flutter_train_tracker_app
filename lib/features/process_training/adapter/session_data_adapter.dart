// lib/features/process_training/adapter/session_data_adapter.dart
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';



/// Adapter class that transforms raw SessionEntity data into UI models.
class SessionDataAdapter {
  // Singleton pattern.
  SessionDataAdapter._internal();
  static final SessionDataAdapter _instance = SessionDataAdapter._internal();
  factory SessionDataAdapter() => _instance;

  /// Transforms a SessionEntity into a SessionTile.
  SessionTile transformSessionToTile(
    SessionEntity session, {
    required ExerciseEntity exercise,
    required MuscleEntity muscle,
  }) {
    final int daysSince = DateTime.now().difference(session.timeStamp).inDays;
    final List<String> images = exerciseImagePaths(exercise);
    return SessionTile(
      exerciseName: exercise.name,
      pathImages: images,
      muscleGroup: muscle.name,
      timeSinceLastSession: daysSince,
      minWeight: session.minWeight.toDouble(),
      maxWeight: session.maxWeight.toDouble(),
      minReps: session.minReps,
      maxReps: session.maxReps,
    );
  }

  /// Returns the image paths for the given exercise.
  List<String> exerciseImagePaths(ExerciseEntity exercise) {
    final commonPath = "assets/images/exercises/${exercise.id}";
    return ["$commonPath.webp", "${commonPath}2.png"];
  }
}