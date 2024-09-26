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
  Future<List<SessionEntity>> fetchLastSessions(List<String> exerciseIds);
  Future<List<SessionEntity>> fetchAllSessions();
  Future<void> createNewSession(SessionEntity session);
}