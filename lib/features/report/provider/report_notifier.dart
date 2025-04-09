// lib/features/report/provider/report_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/features/report/provider/report_state.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:collection/collection.dart';

class ReportNotifier extends StateNotifier<ReportState> {
  final MuscleRepository muscleRepository;
  final ExerciseRepository exerciseRepository;
  final SessionRepository sessionRepository;

  ReportNotifier({
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.sessionRepository,
  }) : super(ReportState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await _fetchAllData();
    selectMuscleById('');
    _filterSessions();
    _filterSessionsByDate();
  }

  Future<void> _fetchAllData() async {
    final muscles = await muscleRepository.fetchAllMuscles();
    final exercises = await exerciseRepository.fetchAllExercises();
    final allSessions = await sessionRepository.fetchAllSessions();

    state = state.copyWith(
      allMuscles: muscles,
      allExercises: exercises,
      allSessions: allSessions,
    );

    _filterSessions();
    _filterSessionsByDate();
  }

  bool _filterLogic(SessionEntity session) {
    final sameMonthYear =
        session.timeStamp.month == state.selectedMonth &&
        session.timeStamp.year == state.selectedYear;

    bool sameMuscle = true;
    bool sameExercise = true;

    if (state.selectedMuscle != null && state.selectedMuscle!.id.isNotEmpty) {
      sameMuscle = (session.muscleId == state.selectedMuscle!.id);
    }
    if (state.selectedExercise != null && state.selectedExercise!.id.isNotEmpty) {
      sameExercise = (session.exerciseId == state.selectedExercise!.id);
    }

    return sameMonthYear && sameMuscle && sameExercise;
  }

  void _filterSessions() {
    final filtered = state.allSessions.where(_filterLogic).toList();
    state = state.copyWith(filteredSessions: filtered);
  }

  void _filterSessionsByDate() {
    final filtered = state.allSessions
        .where((session) =>
            session.timeStamp.month == state.selectedMonth &&
            session.timeStamp.year == state.selectedYear)
        .toList();
    state = state.copyWith(filteredSessionsByDate: filtered);
  }

  MuscleEntity? _retrieveMuscleById(String muscleId) {
    return state.allMuscles.firstWhereOrNull((m) => m.id == muscleId);
  }

  ExerciseEntity? _retrieveExerciseById(String exerciseId) {
    return state.allExercises.firstWhereOrNull((e) => e.id == exerciseId);
  }

  void selectMuscleById(String muscleId) {
    MuscleEntity? selectedMuscle;
    List<ExerciseEntity> filteredExercises = state.allExercises;

    if (muscleId.isNotEmpty) {
      selectedMuscle = _retrieveMuscleById(muscleId);
      if (selectedMuscle != null) {
        filteredExercises = state.allExercises
            .where((exercise) => exercise.muscleId == selectedMuscle!.id)
            .toList();
      }
    }

    state = state.copyWith(
      selectedMuscle: selectedMuscle,
      selectedExercise: null, // reset exercise
      filteredExercises: filteredExercises,
    );
  }

  void selectExerciseById(String exerciseId) {
    final selectedExercise = _retrieveExerciseById(exerciseId);
    state = state.copyWith(selectedExercise: selectedExercise);
  }

  void selectMonthYear(int monthNum, int year) {
    if (monthNum < 1 || monthNum > 12) {
      return;
    }
    state = state.copyWith(
      selectedMonth: monthNum,
      selectedYear: year,
    );
    _filterSessions();
    _filterSessionsByDate();
  }
}
