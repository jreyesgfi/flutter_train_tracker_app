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