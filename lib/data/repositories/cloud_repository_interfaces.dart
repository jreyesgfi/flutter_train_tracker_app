import 'package:gymini/domain_layer/entities/core_entities.dart';

abstract class MuscleRepository {
  Future<List<MuscleEntity>> fetchAllMuscles();
}

abstract class ExerciseRepository {
  Future<List<ExerciseEntity>> fetchAllExercises();
}

abstract class SessionRepository {
  Future<List<SessionEntity>> fetchAllSessions();
  Future<void> createNewSession(SessionEntity session);
  Future<List<SessionEntity>> fetchSessionsByMuscleId(String muscleId);
  Future<List<SessionEntity>> fetchSessionsByExerciseId(String exerciseId);
  Future<SessionEntity?> fetchLastSessionByMuscleId(String muscleId);
  Future<SessionEntity?> fetchLastSessionByExerciseId(String exerciseId);
}