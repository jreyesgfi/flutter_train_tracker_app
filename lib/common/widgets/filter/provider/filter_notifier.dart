// lib/features/report/provider/report_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/widgets/filter/utils/filters.dart';
import 'package:gymini/common/shared_data/streams/global_stream.dart';
import 'package:gymini/common/widgets/filter/provider/filter_state.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

class FilterNotifier extends StateNotifier<FilterState> {
  final MuscleRepository muscleRepository;
  final ExerciseRepository exerciseRepository;
  final SessionRepository sessionRepository;
  final GlobalSharedStreams sharedStreams;

  late final StreamSubscription<LogFilter?> _filterSubscription;

  FilterNotifier({
    required this.muscleRepository,
    required this.exerciseRepository,
    required this.sessionRepository,
    required this.sharedStreams,
  })
      : super(FilterState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await _fetchAllData();
    selectMuscleById('');
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
    });
  }

  void _updateFilters() async {
    LogFilter? filter = sharedStreams.logFilterStream.latestValue;
    state = state.copyWith(
      logFilter: filter,
    );
  }

  void _filterSessions() {
    final filtered = Filters.filterSessions(
      state.allSessions,
      state.logFilter,
    );
    state = state.copyWith(filteredSessions: filtered);
  }

  void _filterSessionsByDate() {
    final filteredSessions = Filters.filterSessions(
      state.allSessions, 
      state.logFilter.copyWith(musclePicked: null, exercisePicked: null)
    );
    state = state.copyWith(filteredSessionsByDate: filteredSessions);
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
            .where((exercise) => exercise.muscleId == selectedMuscle?.id)
            .toList();
      }
    }

    state = state.copyWith(
      logFilter: state.logFilter.copyWith(
        musclePicked: selectedMuscle,
        exercisePicked: null,
      ),
      filteredExercises: filteredExercises,
    );
  }

  void selectExerciseById(String exerciseId) {
    final selectedExercise = _retrieveExerciseById(exerciseId);
    state = state.copyWith(
      logFilter: state.logFilter.copyWith(
        exercisePicked: selectedExercise,
      ),
    );
  }

  void selectTimeRange(Tuple2<DateTime?, DateTime?> timeRange) {
    state = state.copyWith(
      logFilter: state.logFilter.copyWith(
        timeRange: timeRange,
      ),
    );
    _filterSessions();
    _filterSessionsByDate();
  }

  @override
  void dispose() {
    _filterSubscription.cancel();
    super.dispose();
  }
}
