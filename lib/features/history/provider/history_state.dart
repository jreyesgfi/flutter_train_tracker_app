// lib/features/history/provider/history_state.dart
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';
import 'package:tuple/tuple.dart';

class HistoryState implements SessionLogProviderState {
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<SessionEntity> allSessions;
  @override
  final List<SessionEntity> filteredSessions;
  @override
  final LogFilter logFilter;  
  
  const HistoryState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.allSessions = const [],
    this.filteredSessions = const [],
    this.logFilter = const LogFilter(),
  });
  
  factory HistoryState.initial() {
    final now = DateTime.now();
    return HistoryState(
      logFilter: LogFilter(
        timeRange: Tuple2<DateTime?, DateTime?>(now.subtract(const Duration(days: 30)), now),
        musclePicked: null,
        exercisePicked: null,
      ),
    );
  }
  
  HistoryState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<SessionEntity>? allSessions,
    List<SessionEntity>? filteredSessions,
    LogFilter? logFilter,
  }) {
    return HistoryState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      allSessions: allSessions ?? this.allSessions,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      logFilter: logFilter ?? this.logFilter,
    );

    // allMuscles: valueOrCurrent(allMuscles, this.allMuscles),
    //   allExercises: valueOrCurrent(allExercises, this.allExercises),
    //   allSessions: valueOrCurrent(allSessions, this.allSessions),
    //   filteredSessions: valueOrCurrent(filteredSessions, this.filteredSessions),
    //   selectedMuscle: valueOrCurrent(selectedMuscle, this.selectedMuscle),
    //   selectedExercise: valueOrCurrent(selectedExercise, this.selectedExercise),
    //   selectedMonth: valueOrCurrent(selectedMonth, this.selectedMonth),
    //   selectedYear: valueOrCurrent(selectedYear, this.selectedYear),
  }
}
