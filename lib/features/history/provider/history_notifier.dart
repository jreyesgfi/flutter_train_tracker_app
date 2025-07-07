// lib/features/history/provider/history_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/widgets/filter/utils/filters.dart';
import 'package:gymini/common/shared_data/streams/global_stream.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:gymini/features/history/provider/history_state.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';

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
      logFilter: filter
    );
  }

  // Filter sessions based on the selected month/year and filters.
  void _filterSessions() {
    List<SessionEntity> filteredSessions = Filters.filterSessions(
      state.allSessions,
      state.logFilter
    );
    state = state.copyWith(filteredSessions: filteredSessions);
  }

  void setFilters(LogFilter filter) {
    state = state.copyWith(
      logFilter: filter
    );
    _filterSessions();
  }
}
