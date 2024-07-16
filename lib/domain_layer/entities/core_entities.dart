class MuscleData {
  final String id;
  final String name;

  MuscleData({required this.id, required this.name});

  factory MuscleData.fromJson(Map<String, dynamic> json) {
    return MuscleData(
      id: json['muscleId'] as String,
      name: json['name'] as String,
    );
  }
}

class ExerciseData {
  final String id;
  final String name;
  final String muscleId;

  ExerciseData({required this.id, required this.name, required this.muscleId});
  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      id: json['exerciseId'] as String,
      name: json['name'] as String,
      muscleId: json['muscleId'] as String
    );
  }

}

class SessionData {
  final String id;
  final String exerciseId;
  final String muscleId;
  final DateTime timeStamp;
  final double maxWeight;
  final double minWeight;
  final int maxReps;
  final int minReps;

  SessionData({
    required this.id,
    required this.exerciseId,
    required this.muscleId,
    required this.timeStamp,
    required this.maxWeight,
    required this.minWeight,
    required this.maxReps,
    required this.minReps,
  });
}
