
import 'package:gymini/domain_layer/entities/core_entities.dart';

class LogFilter {
  final int startYear;
  final int startMonth;
  final int endYear;
  final int endMonth;
  final MuscleEntity? musclePicked;    // Assuming MuscleEntity comes from your core_entities.dart
  final ExerciseEntity? exercisePicked;  // Define this similar to MuscleEntity if not already available

  LogFilter({
    required this.startYear,
    required this.startMonth,
    required this.endYear,
    required this.endMonth,
    this.musclePicked,
    this.exercisePicked,
  });

  LogFilter copyWith({
    int? startYear,
    int? startMonth,
    int? endYear,
    int? endMonth,
    MuscleEntity? musclePicked,
    ExerciseEntity? exercisePicked,
  }) {
    return LogFilter(
      startYear: startYear ?? this.startYear,
      startMonth: startMonth ?? this.startMonth,
      endYear: endYear ?? this.endYear,
      endMonth: endMonth ?? this.endMonth,
      musclePicked: musclePicked ?? this.musclePicked,
      exercisePicked: exercisePicked ?? this.exercisePicked,
    );
  }
}
