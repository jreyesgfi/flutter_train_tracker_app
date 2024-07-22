class MuscleEntity {
  final String id;
  final String name;

  MuscleEntity({required this.id, required this.name});

  factory MuscleEntity.fromJson(Map<String, dynamic> json) {
    return MuscleEntity(
      id: json['muscleId'] as String,
      name: json['name'] as String,
    );
  }
}

class ExerciseEntity {
  final String id;
  final String name;
  final String muscleId;

  ExerciseEntity({required this.id, required this.name, required this.muscleId});
  factory ExerciseEntity.fromJson(Map<String, dynamic> json) {
    return ExerciseEntity(
      id: json['exerciseId'] as String,
      name: json['name'] as String,
      muscleId: json['muscleId'] as String
    );
  }

}

class SessionEntity {
  final String id;
  final String exerciseId;
  final String muscleId;
  final DateTime timeStamp;
  final double maxWeight;
  final double minWeight;
  final int maxReps;
  final int minReps;

  SessionEntity({
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
