import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/infrastructure_layer/network/exercise_data_service.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/exercise_repository_impl.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/session_repository_impl.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

// Define a provider for the notifier
final reportScreenProvider =
    StateNotifierProvider<ReportingScreenNotifier, ReportingScreenState>((ref) {
  return ReportingScreenNotifier(ref);
});

final nullMuscle = MuscleEntity(id:'',name:'');

class ReportingScreenState {
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<ExerciseEntity> filteredExercises;
  final List<SessionEntity> filteredSessions;
  final List<SessionEntity> allSessions;

  MuscleEntity? selectedMuscle;
  ExerciseEntity? selectedExercise;
  int selectedMonth;
  int selectedYear;

  ReportingScreenState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.filteredSessions = const [],
    this.allSessions = const [],
    this.selectedMuscle,
    this.selectedExercise,
    required this.selectedMonth,
    required this.selectedYear,
  });

  factory ReportingScreenState.initial() {
    final now = DateTime.now();
    return ReportingScreenState(
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  ReportingScreenState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<ExerciseEntity>? filteredExercises,
    List<SessionEntity>? filteredSessions,
    List<SessionEntity>? allSessions,
    MuscleEntity? selectedMuscle,
    ExerciseEntity? selectedExercise,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return ReportingScreenState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      filteredSessions: filteredSessions ?? this.filteredSessions,
      allSessions: allSessions ?? this.allSessions,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class ReportingScreenNotifier extends StateNotifier<ReportingScreenState> {
  final Ref ref;

  ReportingScreenNotifier(this.ref) : super(ReportingScreenState.initial()) {
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    print("Fetching all data");
    final muscles = await ref.read(muscleRepositoryProvider).fetchAllMuscles();
    final exercises =
        await ref.read(exerciseRepositoryProvider).fetchAllExercises();
    final allSessions =
        await ref.read(sessionRepositoryProvider).fetchAllSessions();

    state = state.copyWith(
      allMuscles: muscles,
      allExercises: exercises,
      allSessions: allSessions,
    );

    filterSessions();
  }

  void filterSessions() {
    List<SessionEntity> filteredSessions = state.allSessions;
    print(" Muscle selected ${state.selectedMuscle}");
    // Filter by selected muscle
    if (state.selectedMuscle != nullMuscle) {
      filteredSessions = filteredSessions
          .where((session) => session.muscleId == state.selectedMuscle!.id)
          .toList();
    } else {
      print("No muscle selected");
      filteredSessions = state.allSessions;
    }

    // Further filter by selected exercise
    if (state.selectedExercise != null) {
      filteredSessions = filteredSessions
          .where((session) => session.exerciseId == state.selectedExercise!.id)
          .toList();
    }

    state = state.copyWith(filteredSessions: filteredSessions);
    print("Sessions filtered: ${filteredSessions.length}");
  }

  void selectMuscleById(String muscleId) {
    print("Selecting muscle asociated with $muscleId...");
    MuscleEntity? selectedMuscle = nullMuscle;
    if (muscleId != '') {
      // Find the muscle by ID, if it exists
      selectedMuscle =
          state.allMuscles.firstWhereOrNull((m) => m.id == muscleId);
    }
    print("Selected muscle: $selectedMuscle");
    // Update the state with the selected muscle and filtered exercises
    state = state.copyWith(
      selectedMuscle: selectedMuscle,
      selectedExercise: null,
    );
  }

  void selectExerciseById(String exerciseId) {
    final selectedExercise =
        state.allExercises.firstWhereOrNull((e) => e.id == exerciseId);

    state = state.copyWith(
      selectedExercise: selectedExercise,
    );
  }

  void selectMonthYear(int monthNum, int year) {
    if (monthNum < 1 || monthNum > 12) {
      return;
    }

    state = state.copyWith(
      selectedMonth: monthNum,
      selectedYear: year,
    );
  }
}
