class SessionInfoSchema {
  final String exerciseName;
  final String muscleGroup;
  final int timeSinceLastSession; // in days
  final double minWeight;
  final double maxWeight;
  final int minReps;
  final int maxReps;

  SessionInfoSchema({
    required this.exerciseName,
    required this.muscleGroup,
    required this.timeSinceLastSession,
    required this.minWeight,
    required this.maxWeight,
    required this.minReps,
    required this.maxReps,
  });
}

class SessionValues {
  final double maxWeight;
  final double minWeight;
  final int minReps;
  final int maxReps;

  SessionValues({
    this.maxWeight = 10.0,
    this.minWeight = 10.0,
    this.maxReps = 10,
    this.minReps = 10,
  });
}