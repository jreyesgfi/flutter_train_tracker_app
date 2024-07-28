import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'dart:math';

class MockDataRepository {
  List<MuscleEntity> muscles = [
    MuscleEntity(id: "m1", name: "Pecho"),
    MuscleEntity(id: "m2", name: "Hombros"),
    MuscleEntity(id: "m3", name: "Piernas"),
    MuscleEntity(id: "m4", name:"Triceps"),
    MuscleEntity(id: "m5", name: "Biceps"),
    MuscleEntity(id: "m6", name: "Espalda (dorsal)")
  ];

  List<ExerciseEntity> exercises = [
    ExerciseEntity(id: "e1", name: "Bench Press", muscleId: "m1"),
    ExerciseEntity(id: "e2", name: "Flyes", muscleId: "m1"),
    ExerciseEntity(id: "e3", name: "Dumbbell Front Raises", muscleId: "m2"),
    ExerciseEntity(id: "e4", name: "Dumbbell Lateral Raises", muscleId: "m2"),
    ExerciseEntity(id: "e5", name: "Seated Leg Curl", muscleId: "m3"),
    ExerciseEntity(id: "e6", name: "Leg Press", muscleId: "m3"),
    ExerciseEntity(id: "e7", name: "Push Up", muscleId: "m1"),
    ExerciseEntity(id: "e8", name: "Seated Military Shoulder Press", muscleId: "m2"),
    ExerciseEntity(id: "e9", name: "Standing Calf Raises", muscleId: "m3"),
    ExerciseEntity(id: "e10", name: "Extensiones de triceps una mano", muscleId: "m4"),
    ExerciseEntity(id: "e11", name: "Extensiones de triceps supinas una mano", muscleId: "m4"),
    ExerciseEntity(id: "e12", name: "Curl Biceps con rotación a pecho", muscleId: "m5"),
    ExerciseEntity(id: "e13", name: "Curl Biceps concentrado", muscleId: "m5"),
    ExerciseEntity(id: "e14", name: "Curl Biceps Overhead", muscleId: "m5"),
    ExerciseEntity(id: "e15", name: "Remo Vertical", muscleId: "m6"),
    ExerciseEntity(id: "e16", name: "Remo Horizontal", muscleId: "m6"),
  ];

  late List<SessionEntity> sessions;

  MockDataRepository() {
    Random random = Random();

    sessions = List.generate(27, (index) {
      int exerciseIndex = index % exercises.length; // each exercise gets 3 sessions
      var exercise = exercises[exerciseIndex];
      var muscle = muscles.firstWhere((m) => m.id == exercise.muscleId);

      return SessionEntity(
        id: "s${index + 1}",
        exerciseId: exercise.id,
        muscleId: muscle.id,
        timeStamp: DateTime.now().subtract(Duration(days: 1)), 
        maxWeight: 10 + random.nextDouble()*5,
        minWeight: 5 + random.nextDouble()*5,
        maxReps: 10,
        minReps: 10,
      );
    });

    // Quintuplicate the sessions with increased randomness
    List<SessionEntity> newSessions = [];
    for (var session in sessions) {
      double lastMaxWeight = session.maxWeight;
      double lastMinWeight = session.minWeight;
      int lastMaxReps = session.maxReps;
      int lastMinReps = session.minReps;

      for (int i = 0; i < 15; i++) {
        lastMaxWeight -= random.nextDouble()*0.2;
        lastMinWeight -= random.nextDouble()*0.2;
        lastMaxReps = 12;
        lastMinReps = 10;

        newSessions.add(SessionEntity(
          id: "${session.id}_q$i",
          exerciseId: session.exerciseId,
          muscleId: session.muscleId,
          timeStamp: session.timeStamp.subtract(Duration(days: i*3+random.nextInt(3))),
          maxWeight: lastMaxWeight,
          minWeight: lastMinWeight,
          maxReps: lastMaxReps,
          minReps: lastMinReps,
        ));
      }
    }

    sessions = newSessions;
  }

  Future<List<MuscleEntity>> fetchAllMuscles() async {
    return muscles;
  }

  Future<List<ExerciseEntity>> fetchAllExercises() async {
    return exercises;
  }

  Future<SessionEntity> fetchLastSessionForExercise(String exerciseId) async {
    return sessions.where((s) => s.exerciseId == exerciseId).reduce((a, b) => a.timeStamp.isAfter(b.timeStamp) ? a : b);
  }

  Future<List<SessionEntity>> fetchFilteredSessions({String? muscleId, String? exerciseId}) async {
    if (muscleId == null && exerciseId == null){
      return sessions;
    }
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

  Future<List<SessionEntity>> fetchLastSessions() async {
    Map<String, SessionEntity> latestSessions = {};
    for (var session in sessions) {
      if (!latestSessions.containsKey(session.exerciseId) || latestSessions[session.exerciseId]!.timeStamp.isBefore(session.timeStamp)) {
        latestSessions[session.exerciseId] = session;
      }
    }
    return latestSessions.values.toList();
  }
}
