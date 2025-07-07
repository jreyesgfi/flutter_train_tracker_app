import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:tuple/tuple.dart';

class FilterState {
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<ExerciseEntity> filteredExercises;
  final List<SessionEntity> filteredSessions;
  final List<SessionEntity> filteredSessionsByDate;
  final List<SessionEntity> allSessions;

  final LogFilter logFilter;

  const FilterState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.filteredSessions = const [],
    this.filteredSessionsByDate = const [],
    this.allSessions = const [],
    required this.logFilter,
  });

  factory FilterState.initial() {
    final now = DateTime.now();
    LogFilter initialFilter = LogFilter(
      timeRange: Tuple2<DateTime?, DateTime?>(now.subtract(const Duration(days: 30)), now),
      musclePicked: null,
      exercisePicked: null,
    );
    return FilterState(
      logFilter: initialFilter,
    );
  }

  FilterState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<ExerciseEntity>? filteredExercises,
    List<SessionEntity>? filteredSessions,
    List<SessionEntity>? filteredSessionsByDate,
    List<SessionEntity>? allSessions,
    LogFilter? logFilter,
  }) {
    return FilterState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      filteredSessionsByDate: filteredSessionsByDate ?? this.filteredSessionsByDate,
      allSessions: allSessions ?? this.allSessions,
      logFilter: logFilter ?? this.logFilter,
    );
  }
}
