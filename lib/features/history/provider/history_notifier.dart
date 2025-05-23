// lib/features/history/provider/history_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/streams/global_stream.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:gymini/features/history/provider/history_state.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:collection/collection.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  final MuscleRepository muscleRepository;
  final ExerciseRepository exerciseRepository;
  final SessionRepository sessionRepository;
  final LocalRepository localRepository;
  final GlobalSharedStreams sharedStreams;

  HistoryNotifier({
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.sessionRepository,
    required this.localRepository,
    required this.sharedStreams,
  }) : super(HistoryState.initial()) {
    _fetchAllData();
    _subscribeToStreams();
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
  }

  void _subscribeToStreams() {
    // Listen for changes to the filter
    sharedStreams.logFilterStream.stream.listen((filter) async {
      _updateFilters();
      _filterSessions();
    });
  }

  void _updateFilters() async {
    LogFilter? filter = sharedStreams.logFilterStream.latestValue;
    state = state.copyWith(
      selectedMuscle: filter?.musclePicked,
      selectedExercise: filter?.exercisePicked,
      selectedMonth: filter?.startMonth ?? DateTime.now().month,
      selectedYear: filter?.startYear ?? DateTime.now().year,
    );
  }

  // Filter sessions based on the selected month/year and filters.
  void _filterSessions() {
    final filtered = state.allSessions.where((session) {
      final sameMonthYear = session.timeStamp.month == state.selectedMonth &&
          session.timeStamp.year == state.selectedYear;
      bool sameMuscle = true, sameExercise = true;
      if (state.selectedMuscle != null && state.selectedMuscle!.id.isNotEmpty) {
        sameMuscle = (session.muscleId == state.selectedMuscle!.id);
      }
      if (state.selectedExercise != null && state.selectedExercise!.id.isNotEmpty) {
        sameExercise = (session.exerciseId == state.selectedExercise!.id);
      }
      return sameMonthYear && sameMuscle && sameExercise;
    }).toList();
    state = state.copyWith(filteredSessions: filtered);
  }

  // Set filters (for example, muscle/exercise, month, year) and re-filter.
  void setFilters({String? muscleId, String? exerciseId, int? month, int? year}) {
    MuscleEntity? selectedMuscle;
    ExerciseEntity? selectedExercise;
    if (muscleId != null && muscleId.isNotEmpty) {
      selectedMuscle = state.allMuscles.firstWhereOrNull((m) => m.id == muscleId);
    }
    if (exerciseId != null && exerciseId.isNotEmpty) {
      selectedExercise = state.allExercises.firstWhereOrNull((e) => e.id == exerciseId);
    }
    state = state.copyWith(
      selectedMuscle: selectedMuscle,
      selectedExercise: selectedExercise,
      selectedMonth: month ?? state.selectedMonth,
      selectedYear: year ?? state.selectedYear,
    );
    _filterSessions();
  }
}
