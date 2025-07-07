// lib/features/report/provider/report_state.dart
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';
import 'package:tuple/tuple.dart';

class ReportState implements SessionLogGrainedProviderState{
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<ExerciseEntity> filteredExercises;
  final List<SessionEntity> allSessions;
  @override
  final List<SessionEntity> filteredSessions;
  @override
  final List<SessionEntity> filteredSessionsByDate;
  @override
  final LogFilter logFilter;

  const ReportState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.filteredSessions = const [],
    this.filteredSessionsByDate = const [],
    this.allSessions = const [],
    this.logFilter = const LogFilter(),
  });

  factory ReportState.initial() {
    final now = DateTime.now();
    return ReportState(
      logFilter: LogFilter(
        timeRange: Tuple2<DateTime?, DateTime?>(now.subtract(const Duration(days: 30)), now),
        musclePicked: null,
        exercisePicked: null,
      ),
    );
  }

  ReportState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<ExerciseEntity>? filteredExercises,
    List<SessionEntity>? filteredSessions,
    List<SessionEntity>? filteredSessionsByDate,
    List<SessionEntity>? allSessions,
    LogFilter? logFilter,
  }) {
    return ReportState(
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
