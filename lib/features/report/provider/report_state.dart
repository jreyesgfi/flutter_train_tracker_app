// lib/features/report/provider/report_state.dart
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';

class ReportState implements SessionLogGrainedProviderState{
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<ExerciseEntity> filteredExercises;
  final List<SessionEntity> allSessions;
  final MuscleEntity? selectedMuscle;
  final ExerciseEntity? selectedExercise;
  @override
  final List<SessionEntity> filteredSessions;
  @override
  final List<SessionEntity> filteredSessionsByDate;
  @override
  final int selectedMonth;
  @override
  final int selectedYear;

  const ReportState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.filteredSessions = const [],
    this.filteredSessionsByDate = const [],
    this.allSessions = const [],
    this.selectedMuscle,
    this.selectedExercise,
    required this.selectedMonth,
    required this.selectedYear,
  });

  factory ReportState.initial() {
    final now = DateTime.now();
    return ReportState(
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  ReportState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<ExerciseEntity>? filteredExercises,
    List<SessionEntity>? filteredSessions,
    List<SessionEntity>? filteredSessionsByDate,
    List<SessionEntity>? allSessions,
    MuscleEntity? selectedMuscle,
    ExerciseEntity? selectedExercise,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return ReportState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      filteredSessionsByDate: filteredSessionsByDate ?? this.filteredSessionsByDate,
      allSessions: allSessions ?? this.allSessions,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}
