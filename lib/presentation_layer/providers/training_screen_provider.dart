import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gymini/domain_layer/entities/session_info.dart';
import 'package:gymini/infrastructure_layer/network/exercise_data_service.dart';
import 'package:gymini/infrastructure_layer/repository_impl/exercise_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/local_data_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/session_repository_impl.dart';
import 'package:gymini/presentation_layer/services/training_data_transformer.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:uuid/uuid.dart';

// Define a provider for the notifier
final trainingScreenProvider =
    StateNotifierProvider<TrainingScreenNotifier, TrainingScreenState>((ref) {
  return TrainingScreenNotifier(ref);
});

class TrainingScreenState {
  final List<MuscleEntity> allMuscles;
  final List<ExerciseEntity> allExercises;
  final List<ExerciseEntity> filteredExercises;
  final List<SessionEntity> allLastSessions;
  final Map<String, DateTime> lastMuscleTrainingTimes;
  final List<MuscleTileSchema> muscleTiles;
  final List<ExerciseTileSchema> exerciseTiles;

  MuscleEntity? selectedMuscle;
  ExerciseEntity? selectedExercise;
  SessionEntity? lastSession;
  SessionInfoSchema? lastSessionSummary;

  SessionEntity? newSession;

  int currentStage;

  TrainingScreenState({
    this.allMuscles = const [],
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.allLastSessions = const [],
    //this.lastTrainingTimes = const {},
    this.lastMuscleTrainingTimes = const {},
    this.muscleTiles = const [],
    this.exerciseTiles = const [],
    this.selectedMuscle,
    this.selectedExercise,
    this.lastSession,
    this.lastSessionSummary,
    this.newSession,
    this.currentStage = 0,
  });

  static initial() {
    return TrainingScreenState();
  }

  TrainingScreenState copyWith({
    List<MuscleEntity>? allMuscles,
    List<ExerciseEntity>? allExercises,
    List<ExerciseEntity>? filteredExercises,
    List<SessionEntity>? allLastSessions,
    //Map<String, DateTime>? lastTrainingTimes,
    Map<String, DateTime>? lastMuscleTrainingTimes,
    List<MuscleTileSchema>? muscleTiles,
    List<ExerciseTileSchema>? exerciseTiles,
    MuscleEntity? selectedMuscle,
    ExerciseEntity? selectedExercise,
    SessionEntity? lastSession,
    SessionInfoSchema? lastSessionSummary,
    SessionEntity? newSession,
    int? currentStage,
  }) {
    return TrainingScreenState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      allLastSessions: allLastSessions ?? this.allLastSessions,
      //lastTrainingTimes: lastTrainingTimes ?? this.lastTrainingTimes,
      lastMuscleTrainingTimes:
          lastMuscleTrainingTimes ?? this.lastMuscleTrainingTimes,
      muscleTiles: muscleTiles ?? this.muscleTiles,
      exerciseTiles: exerciseTiles ?? this.exerciseTiles,
      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      lastSession: lastSession ?? this.lastSession,
      lastSessionSummary: lastSessionSummary ?? this.lastSessionSummary,
      newSession: newSession ?? this.newSession,
      currentStage: currentStage ?? this.currentStage,
    );
  }
}

class TrainingScreenNotifier extends StateNotifier<TrainingScreenState> {
  final Ref ref;

  TrainingScreenNotifier(this.ref) : super(TrainingScreenState.initial()) {
    _fetchAllData();
  }

  // CLOUD STORAGE DATA
  Future<void> _fetchAllData() async {
    print("Fetching all data");
   final muscles = await ref.read(muscleRepositoryProvider).fetchAllMuscles();
    final exercises =
        await ref.read(exerciseRepositoryProvider).fetchAllExercises();
    final exerciseIds =
        exercises.map((ExerciseEntity exercise) => exercise.id).toList();
      await ref.read(sessionRepositoryProvider).fetchAllSessions();
    final lastSessions = await ref.read(sessionRepositoryProvider)
        .fetchLastSessionsByExerciseIds(exerciseIds);
  
    final lastMuscleTimes = await ref
      .read(sessionRepositoryProvider)
      .fetchLastSessionsByMuscleIds(muscles.map((muscle)=>muscle.id).toList());

    final lastExerciseTimes = await ref
      .read(sessionRepositoryProvider)
      .fetchLastSessionsByExerciseIds(exerciseIds);

    state = state.copyWith(
        allMuscles: muscles,
        allExercises: exercises,
        allLastSessions: lastSessions,
    );
    //_updateLastTrainingTimes();
    _updateTiles();
  }

  void _updateMuscleTiles() async{
    var likedMuscles = await _getLikedMuscles();
    var newMuscleTiles = TrainingDataTransformer.transformMusclesToTiles(
        state.allMuscles, state.lastMuscleTrainingTimes, likedMuscles);
    state = state.copyWith(
      muscleTiles: newMuscleTiles,
    );
  }

  // void _updateLastTrainingTimes(){
  //   Map<String, DateTime> lastMuscleTrainingTimes = {};
  //   for (var session in state.allLastSessions) {
  //     // Check if the muscleId is already in the dictionary
  //     if (!lastMuscleTrainingTimes.containsKey(session.muscleId)) {
  //       // If not, add it with the current session's timestamp
  //       lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
  //     } else {
  //       // If it exists, compare and save the later date
  //       if (lastMuscleTrainingTimes[session.muscleId]!
  //           .isBefore(session.timeStamp)) {
  //         lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
  //       }
  //     }
  //   }

  //   Map<String, DateTime> lastTrainingTimes = {};
  //   for (var session in state.allLastSessions){
  //     lastTrainingTimes[session.exerciseId] = session.timeStamp;
  //   }
  //   state = state.copyWith(
  //       lastMuscleTrainingTimes: lastMuscleTrainingTimes,
  //       lastTrainingTimes: lastTrainingTimes,
  //   );
  // }


  // LOCAL STORAGE DATA
  Future<List<String>> _getLikedMuscles() async{
    return await ref.read(localRepositoryProvider).getLikedMuscles();
  }

  Future<List<String>> _getLikedExercises() async{
    return await ref.read(localRepositoryProvider).getLikedExercises();
  }
  
  void toggleMuscleLikeState(String muscleId) async{
    await ref.read(localRepositoryProvider).toggleMuscleLikeState(muscleId);
    _getLikedMuscles();
  }
  void toggleExerciseLikeState(String exerciseId) async{
    await ref.read(localRepositoryProvider).toggleExerciseLikeState(exerciseId);
    _getLikedExercises();
  }



  // PROVIDER DATA
  void selectMuscleById(String muscleId) {
    try {
      final selectedMuscle =
          state.allMuscles.firstWhere((m) => m.id == muscleId);
      final filteredExercises = state.allExercises
          .where((e) => e.muscleId == selectedMuscle.id)
          .toList();
      state = state.copyWith(
        selectedMuscle: selectedMuscle,
        filteredExercises: filteredExercises,
      );
    } catch (e) {
      // Handle the case where no muscle matches the ID
      state = state.copyWith(
        selectedMuscle: null,
        filteredExercises: [],
      );
    }
    _updateExerciseTiles();
  }

  ExerciseEntity emptyExercise() => ExerciseEntity(
      id: Uuid().v4(),
      muscleId: selectedMuscle!.id,
      name: "Ningún ejercicio encontrado");

  SessionEntity emptySessionEntity(String? selectedExerciseId) => SessionEntity(
        id: Uuid().v4(),
        exerciseId: selectedExerciseId ?? state.selectedExercise!.id,
        muscleId: state.selectedMuscle!.id,
        timeStamp: DateTime.now(),
        maxWeight: 0,
        minWeight: 0,
        maxReps: 0,
        minReps: 0,
      );

  SessionEntity createNewSessionFromLast(SessionEntity lastSession) {
    return SessionEntity(
      id: Uuid().v4(), // Create a new unique ID
      exerciseId: lastSession.exerciseId,
      muscleId: lastSession.muscleId,
      timeStamp: DateTime.now(),
      maxWeight: lastSession.maxWeight,
      minWeight: lastSession.minWeight,
      maxReps: lastSession.maxReps,
      minReps: lastSession.minReps,
    );
  }

  void selectExerciseById(String exerciseId) {
    print("Select exercise");
    ExerciseEntity selectedExercise;
    SessionEntity lastSession;
    SessionInfoSchema lastSessionSummary;
    try {
      selectedExercise =
          state.allExercises.firstWhere((e) => e.id == exerciseId);
    } catch (e) {
      selectedExercise = emptyExercise();
    }

    try {
      lastSession =
          state.allLastSessions.firstWhere((s) => s.exerciseId == exerciseId);
    } catch (e) {
      lastSession = emptySessionEntity(selectedExercise.id);
      print("Last session empty");
    }
    lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(
      lastSession,
      selectedExercise.name,
      state.selectedMuscle!.name,
    );
    SessionEntity newSession = createNewSessionFromLast(lastSession);

    state = state.copyWith(
      selectedExercise: selectedExercise,
      lastSession: lastSession,
      lastSessionSummary: lastSessionSummary,
      newSession: newSession,
      currentStage: 1,
    );
  }

  ExerciseEntity? get selectedMuscle => state.selectedExercise;
  ExerciseEntity? get selectedExercise => state.selectedExercise;
  List<MuscleTileSchema> get muscleTiles => state.muscleTiles;
  List<ExerciseTileSchema> get exerciseTiles => state.exerciseTiles;
  SessionInfoSchema? get lastSessionSummary => state.lastSessionSummary;
  SessionInfoSchema? get newSessionSchema => state.newSession != null
      ? TrainingDataTransformer.transformSessionToSummary(
          state.newSession,
          selectedExercise!.name,
          state.selectedMuscle!.name,
        )
      : null;

  // VIEW MODEL
  void _updateTiles() async{
    print("Update Tiles");
    var likedMuscles = await _getLikedMuscles();
    var newMuscleTiles = TrainingDataTransformer.transformMusclesToTiles(
        state.allMuscles, state.lastMuscleTrainingTimes, likedMuscles);
    state = state.copyWith(
      muscleTiles: newMuscleTiles,
    );

    _updateExerciseTiles();
  }

  void _updateExerciseTiles() async{
    final likedExercises = await _getLikedExercises();
    var newExerciseTiles = TrainingDataTransformer.transformExercisesToTiles(
        state.filteredExercises, state.lastTrainingTimes, likedExercises);
    state = state.copyWith(
      exerciseTiles: newExerciseTiles,
    );  
  }

  void updateNewSession(SessionValues sessionValues) {
    print("Update new session");
    final newSession = SessionEntity(
        id: state.newSession?.id ??
            const Uuid()
                .v4(), //create a new session id that ensures it is unique for all users and sessions in aws
        exerciseId: state.selectedExercise!.id,
        muscleId: state.selectedMuscle!.id,
        timeStamp: DateTime.now(),
        maxWeight: sessionValues.maxWeight,
        minWeight: sessionValues.minWeight,
        maxReps: sessionValues.maxReps,
        minReps: sessionValues.minReps);

    state = state.copyWith(newSession: newSession);
  }

  Future<void> commitNewSession() async {
    if (state.newSession != null) {
      await ref
          .read(sessionRepositoryProvider)
          .createNewSession(state.newSession!);
      // add it locally
      state.allLastSessions.add(state.newSession!);
      state.lastMuscleTrainingTimes[state.newSession!.muscleId] = state.newSession!.timeStamp;
      state.lastTrainingTimes[state.newSession!.exerciseId] = state.newSession!.timeStamp;
    }
    _updateExerciseTiles();
    print("New Session Committed");
  }

  // STAGES
  void nextStage() {
    state = state.copyWith(currentStage: state.currentStage + 1);
  }

  void previousStage() {
    if (state.currentStage > 0) {
      state = state.copyWith(currentStage: state.currentStage - 1);
    }
  }

  void resetStage() {
    state = state.copyWith(currentStage: 0);
  }

  void setStage(int stage, {bool reset = false}) {
    state = state.copyWith(currentStage: reset ? 0 : stage);
  }
}