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
  final Map<String, DateTime> lastTrainingTimes;
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
    this.lastTrainingTimes = const {},
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
    Map<String, DateTime>? lastTrainingTimes,
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
      lastTrainingTimes: lastTrainingTimes ?? this.lastTrainingTimes,
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

  // DATA CLOUD RETRIVAL
  Future<void> _fetchAllData() async {
    print("Fetching all data");
    final muscles = await ref.read(muscleRepositoryProvider).fetchAllMuscles();
    final exercises =
        await ref.read(exerciseRepositoryProvider).fetchAllExercises();
    final exerciseIds =
        exercises.map((ExerciseEntity exercise) => exercise.id).toList();
    final lastSessions = await ref
        .read(sessionRepositoryProvider)
        .fetchLastSessions(exerciseIds);

    Map<String, DateTime> lastMuscleTrainingTimes = {};
    for (var session in lastSessions) {
      // Check if the muscleId is already in the dictionary
      if (!lastMuscleTrainingTimes.containsKey(session.muscleId)) {
        // If not, add it with the current session's timestamp
        lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
      } else {
        // If it exists, compare and save the later date
        if (lastMuscleTrainingTimes[session.muscleId]!
            .isBefore(session.timeStamp)) {
          lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
        }
      }
    }

    Map<String, DateTime> lastTrainingTimes = {};
    for (var session in lastSessions){
      lastTrainingTimes[session.exerciseId] = session.timeStamp;
    }

    state = state.copyWith(
        allMuscles: muscles,
        allExercises: exercises,
        allLastSessions: lastSessions,
        lastMuscleTrainingTimes: lastMuscleTrainingTimes,
        lastTrainingTimes: lastTrainingTimes,
    );
    _updateTiles();
  }

  // DATA LOCAL FILTER
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
    _updateTiles();
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
        maxWeight: 10,
        minWeight: 10,
        maxReps: 10,
        minReps: 10,
      );

  SessionEntity createNewSessionFromLast(SessionEntity lastSession) {
    return SessionEntity(
      id: Uuid().v4(), // Create a new unique ID
      exerciseId: lastSession.exerciseId,
      muscleId: lastSession.muscleId,
      timeStamp: DateTime.now(), // Update timestamp to current time
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
  void _updateTiles() {
    print("Update Tiles");
    var newMuscleTiles = TrainingDataTransformer.transformMusclesToTiles(
        state.allMuscles, state.lastMuscleTrainingTimes);
    var newExerciseTiles = TrainingDataTransformer.transformExercisesToTiles(
        state.filteredExercises, state.lastTrainingTimes);

    state = state.copyWith(
      muscleTiles: newMuscleTiles,
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





// //provider
// import 'package:flutter/material.dart';
// import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
// import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
// import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';
// import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
// import 'package:flutter_application_test1/domain_layer/entities/session_info.dart'; // Assuming this is where SessionInfoSchema is defined

// class TrainingScreenProvider extends ChangeNotifier {
//   /* DATA SECTION */
//   // Internal State
//   List<MuscleData> _allMuscles = [];
//   List<ExerciseData> _allExercises = [];
//   List<ExerciseData> _filteredExercises = [];
//   List<SessionData> _allLastSessions = [];
//   Map<String, DateTime> _lastTrainingTimes = {};
//   Map<String, DateTime> _lastMuscleTrainingTimes = {};

//   // Currently selected data
//   MuscleData? _selectedMuscle;
//   ExerciseData? _selectedExercise;
//   SessionInfoSchema? _lastSessionSummary;

//   // Tiles
//   List<MuscleTileSchema> _muscleTiles = [];
//   List<ExerciseTileSchema> _exerciseTiles = [];

//   TrainingScreenProvider(
//     List<MuscleData> allMuscles,
//     List<ExerciseData> allExercises,
//     List<SessionData> allLastSessions,
//   ) {
//     _setInitialData(allMuscles, allExercises, allLastSessions);
//   }

//   void _setInitialData(
//     List<MuscleData> allMuscles,
//     List<ExerciseData> allExercises,
//     List<SessionData> allLastSessions,
//   ) {
//     _allMuscles = allMuscles;
//     _allExercises = allExercises;
//     _allLastSessions = allLastSessions;
//     _initializeLastTrainingTimes(_allLastSessions);
//     _updateTiles();
//   }

//   // Initializers
//   void _initializeLastTrainingTimes(List<SessionData> sessions) {
//     for (var session in sessions) {
//       _lastTrainingTimes[session.exerciseId] = session.timeStamp;
      
//       if (_lastMuscleTrainingTimes.containsKey(session.muscleId)) {
//         if (_lastMuscleTrainingTimes[session.muscleId]!.isBefore(session.timeStamp)) {
//           _lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
//         }
//       } else {
//         _lastMuscleTrainingTimes[session.muscleId] = session.timeStamp;
//       }
//     }
//   }

//   void _updateTiles() {
//     _muscleTiles = TrainingDataTransformer.transformMusclesToTiles(_allMuscles, _lastMuscleTrainingTimes);
//     _exerciseTiles = TrainingDataTransformer.transformExercisesToTiles(_filteredExercises, _lastTrainingTimes);
//     notifyListeners();
//   }

//   // GETTERS
//   MuscleData? get selectedMuscle => _selectedMuscle;
//   ExerciseData? get selectedExercise => _selectedExercise;
//   SessionInfoSchema? get lastSessionSummary => _lastSessionSummary;
//   List<MuscleTileSchema> get muscleTiles => _muscleTiles;
//   List<ExerciseTileSchema> get exerciseTiles => _exerciseTiles;

//   // SETTERS
//   void selectMuscleById(String muscleId) {
//     try {
//       _selectedMuscle = _allMuscles.firstWhere((m) => m.id == muscleId);
//     } catch (e) {
//       _selectedMuscle = null;
//     }

//     if (_selectedMuscle != null) {
//       _filteredExercises = _allExercises
//           .where((e) => e.muscleId == _selectedMuscle!.id)
//           .toList();
//     } else {
//       _filteredExercises = []; // Clear exercises if no muscle matches
//     }
//     _updateTiles();
//   }

//   void selectExerciseById(String exerciseId) {
//     try {
//       _selectedExercise = _allExercises.firstWhere((e) => e.id == exerciseId);
//     } catch (e) {
//       _selectedExercise = null;
//     }

//     if (_selectedExercise == null) {
//       _lastSessionSummary = null;
//     } else {
//       try {
//         var lastSession = _allLastSessions.firstWhere((s) => s.exerciseId == exerciseId);
//         _lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(
//         lastSession,
//         _selectedExercise!.name,
//         _selectedMuscle!.name,
//       );
//       } catch(e){
//         _lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(null, "","");
//       }
      
//     }

//     notifyListeners();
//   }

//   void setMuscles(List<MuscleData> muscles) {
//     _allMuscles = muscles;
//     _updateTiles();
//   }

//   void setExercises(List<ExerciseData> exercises) {
//     _allExercises = exercises;
//     _updateTiles();
//   }

//   void setLastSessions(List<SessionData> sessions) {
//     _allLastSessions = sessions;
//     _initializeLastTrainingTimes(sessions);
//     _updateTiles();
//   }

//   /* PAGE SECTION */
//   // Internal State
//   int _currentStage = 0;

//   // Getters
//   int get currentStage => _currentStage;

//   // Setters
//   void nextStage() {
//     _currentStage++;
//     notifyListeners();
//   }

//   void previousStage() {
//     if (_currentStage > 0) {
//       _currentStage--;
//       notifyListeners();
//     }
//   }

//   void resetStage() {
//     _currentStage = 0;
//     notifyListeners();
//   }

//   void setStage(int stage, {bool reset = false}) {
//     if (reset) {
//       _currentStage = 0;
//     } else {
//       _currentStage = stage;
//     }
//     notifyListeners();
//   }
// }
