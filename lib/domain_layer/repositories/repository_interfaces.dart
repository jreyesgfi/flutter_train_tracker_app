import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

abstract class MuscleRepository {
  Future<List<MuscleData>> fetchAllMuscles();
}
// Future<List<ExerciseData>> fetchAllExercises();
//   Future<List<SessionData>> fetchAllSessions();
abstract class SessionRepository {
  Future<SessionData> fetchLastSessionForExercise(String exerciseId);
  Future<List<SessionData>> fetchFilteredSessions({String? muscleId, String? exerciseId});
  Future<List<SessionData>> fetchLastSessions();
}