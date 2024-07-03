import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

class MockDataRepository {
  List<MuscleData> muscles = [
    MuscleData(id: "m1", name: "Pecho"),
    MuscleData(id: "m2", name: "Hombros"),
    MuscleData(id: "m3", name: "Piernas"),
  ];

  List<ExerciseData> exercises = [
    ExerciseData(id: "e1", name: "Bench Press", muscleId: "m1"),
    ExerciseData(id: "e2", name: "Flyes", muscleId: "m1"),
    ExerciseData(id: "e3", name: "Dumbbell Front Raises", muscleId: "m2"),
    ExerciseData(id: "e4", name: "Dumbbell Lateral Raises", muscleId: "m2"),
    ExerciseData(id: "e5", name: "Seated Leg Curl", muscleId: "m3"),
    ExerciseData(id: "e6", name: "Leg Press", muscleId: "m3"),
    ExerciseData(id: "e7", name: "Push Up", muscleId: "m1"),
    ExerciseData(id: "e8", name: "Seated Military Shoulder Press", muscleId: "m2"),
    ExerciseData(id: "e9", name: "Standing Calf Raises", muscleId: "m3"),
  ];

  late List<SessionData> sessions;

  MockDataRepository() {
    sessions = List.generate(27, (index) {
      int exerciseIndex = index % exercises.length; // each exercise gets 3 sessions
      var exercise = exercises[exerciseIndex];
      var muscle = muscles.firstWhere((m) => m.id == exercise.muscleId);

      return SessionData(
        id: "s${index + 1}",
        exerciseId: exercise.id,
        muscleId: muscle.id,
        timeStamp: DateTime.now().subtract(Duration(days: index * 2)), // different days
        maxWeight: 12 + index * 1,
        minWeight: 12 + index * 0.5,
        maxReps: 12 + index % 5,
        minReps: 8 + index % 3,
      );
    });
  }

  Future<List<MuscleData>> fetchAllMuscles() async {
    return muscles;
  }

  Future<List<ExerciseData>> fetchAllExercises() async {
    return exercises;
  }

  Future<SessionData> fetchLastSessionForExercise(String exerciseId) async {
    return sessions.where((s) => s.exerciseId == exerciseId).reduce((a, b) => a.timeStamp.isAfter(b.timeStamp) ? a : b);
  }

  Future<List<SessionData>> fetchFilteredSessions({String? muscleId, String? exerciseId}) async {
    return sessions.where((session) {
      if (muscleId != null && session.muscleId != muscleId) {
        return false;
      }
      if (exerciseId != null && session.exerciseId != exerciseId) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<List<SessionData>> fetchLastSessions() async {
    Map<String, SessionData> latestSessions = {};
    for (var session in sessions) {
      if (!latestSessions.containsKey(session.exerciseId) || latestSessions[session.exerciseId]!.timeStamp.isBefore(session.timeStamp)) {
        latestSessions[session.exerciseId] = session;
      }
    }
    return latestSessions.values.toList();
  }
}
