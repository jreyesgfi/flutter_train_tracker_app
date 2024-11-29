import 'package:gymini/domain_layer/entities/core_entities.dart';

abstract class MuscleRepository {
  Future<List<MuscleEntity>> fetchAllMuscles();
}

abstract class ExerciseRepository {
  Future<List<ExerciseEntity>> fetchAllExercises();
}

abstract class SessionRepository {
  //Future<SessionEntity> fetchLastSessionForExercise(String exerciseId);
  //Future<List<SessionEntity>> fetchFilteredSessions({String? muscleId, String? exerciseId});
  //Future<List<SessionEntity>> fetchLastSessions(List<String> exerciseIds);
  Future<List<SessionEntity>> fetchAllSessions();
  Future<void> createNewSession(SessionEntity session);
  Future<Map<String, SessionEntity>> fetchLastSessionsByExerciseIds();
  Future<Map<String, SessionEntity>> fetchLastSessionsByMuscleIds();
  Future<List<SessionEntity>> fetchSessionsByMuscleId(String muscleId);
  Future<List<SessionEntity>> fetchSessionsByExerciseId(String exerciseId);
}