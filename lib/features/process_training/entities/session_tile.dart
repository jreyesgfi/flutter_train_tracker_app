class SessionTile {
  final String exerciseName;
  final List<String> pathImages;
  final String muscleGroup;
  final int timeSinceLastSession; // in days
  final double minWeight;
  final double maxWeight;
  final int minReps;
  final int maxReps;

  SessionTile({
    required this.exerciseName,
    required this.pathImages,
    required this.muscleGroup,
    required this.timeSinceLastSession,
    required this.minWeight,
    required this.maxWeight,
    required this.minReps,
    required this.maxReps,
  });
}

class SessionFormTile {
  final double maxWeight;
  final double minWeight;
  final int minReps;
  final int maxReps;

  SessionFormTile({
    this.maxWeight = 10.0,
    this.minWeight = 10.0,
    this.maxReps = 10,
    this.minReps = 10,
  });
}