// lib/features/history/provider/history_state.dart
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';

class HistoryState implements SessionLogProviderState {
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<SessionEntity> allSessions;
  final MuscleEntity? selectedMuscle;
  final ExerciseEntity? selectedExercise;
  @override
  final List<SessionEntity> filteredSessions;
  @override
  final int selectedMonth;
  @override
  final int selectedYear;
  
  const HistoryState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.allSessions = const [],
    this.filteredSessions = const [],
    this.selectedMuscle,
    this.selectedExercise,
    required this.selectedMonth,
    required this.selectedYear,
  });
  
  factory HistoryState.initial() {
    final now = DateTime.now();
    return HistoryState(
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }
  
  HistoryState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<SessionEntity>? allSessions,
    List<SessionEntity>? filteredSessions,
    MuscleEntity? selectedMuscle,
    ExerciseEntity? selectedExercise,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return HistoryState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      allSessions: allSessions ?? this.allSessions,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}
