class MuscleData {
  final String id;
  final String name;

  MuscleData({required this.id, required this.name});
}

class ExerciseData {
  final String id;
  final String name;
  final String muscleId;

  ExerciseData({required this.id, required this.name, required this.muscleId});
}

class SessionData {
  final String id;
  final String exerciseId;
  final DateTime timeStamp;
  final double maxWeight;
  final double minWeight;
  final int maxReps;
  final int minReps;

  SessionData({
    required this.id,
    required this.exerciseId,
    required this.timeStamp,
    required this.maxWeight,
    required this.minWeight,
    required this.maxReps,
    required this.minReps,
  });
}
