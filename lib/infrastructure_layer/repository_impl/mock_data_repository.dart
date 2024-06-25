// File: infrastructure_layer/repository_impl/mock_data_repository.dart
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';

class MockDataRepository {
  List<MuscleData> muscles = [
    MuscleData(id: "m1", name: "Chest"),
    MuscleData(id: "m2", name: "Shoulders"),
    MuscleData(id: "m3", name: "Legs"),
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
      int exerciseIndex = index % 9; // each exercise gets 3 sessions
      return SessionData(
        id: "s${index + 1}",
        exerciseId: exercises[exerciseIndex].id,
        timeStamp: DateTime.now().subtract(Duration(days: index * 2)), // different days
        maxWeight: 100 + index * 5.0, // increasing weight
        minWeight: 80 + index * 5.0,
        maxReps: 10 + index % 5,
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

  Future<List<ExerciseData>> fetchExercisesByMuscleId(String muscleId) async {
    return exercises.where((e) => e.muscleId == muscleId).toList();
  }

  Future<SessionData> fetchLastSessionForExercise(String exerciseId) async {
    return sessions.where((s) => s.exerciseId == exerciseId).reduce((a, b) => a.timeStamp.isAfter(b.timeStamp) ? a : b);
  }
}
