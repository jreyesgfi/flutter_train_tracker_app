import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/domain_layer/repositories/repository_interfaces.dart';

// Define a provider for the notifier
final trainingScreenProvider = StateNotifierProvider<TrainingScreenNotifier, TrainingScreenState>((ref) {
  return TrainingScreenNotifier(ref);
});
class TrainingScreenState {
  final List<MuscleData> allMuscles;
  final List<ExerciseData> allExercises;
  final List<ExerciseData> filteredExercises;
  final List<SessionData> allLastSessions;
  final Map<String, DateTime> lastTrainingTimes;
  final Map<String, DateTime> lastMuscleTrainingTimes;

  final List<MuscleTileSchema> muscleTiles;
  final List<ExerciseTileSchema> exerciseTiles;

  MuscleData? selectedMuscle;
  ExerciseData? selectedExercise;
  SessionData? lastSession;
  SessionInfoSchema? lastSessionSummary;

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


    this.currentStage = 0,
  });

  static initial() {
    return TrainingScreenState();
  }

  TrainingScreenState copyWith({
    List<MuscleData>? allMuscles,
    List<ExerciseData>? allExercises,
    List<ExerciseData>? filteredExercises,
    List<SessionData>? allLastSessions,
    Map<String, DateTime>? lastTrainingTimes,
    Map<String, DateTime>? lastMuscleTrainingTimes,

    List<MuscleTileSchema>? muscleTiles,
    List<ExerciseTileSchema>? exerciseTiles,

    MuscleData? selectedMuscle,
    ExerciseData? selectedExercise,
    SessionData? lastSession,
    SessionInfoSchema? lastSessionSummary,

    int? currentStage,
  }) {
    return TrainingScreenState(
      allMuscles: allMuscles ?? this.allMuscles,
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      allLastSessions: allLastSessions ?? this.allLastSessions,
      lastTrainingTimes: lastTrainingTimes ?? this.lastTrainingTimes,
      lastMuscleTrainingTimes: lastMuscleTrainingTimes ?? this.lastMuscleTrainingTimes,
    
      muscleTiles: muscleTiles ?? this.muscleTiles,
      exerciseTiles: exerciseTiles ?? this.exerciseTiles,

      selectedMuscle: selectedMuscle ?? this.selectedMuscle,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      lastSession: lastSession ?? this.lastSession,
      lastSessionSummary: lastSessionSummary ?? this.lastSessionSummary,

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
    final muscles = await ref.read(muscleRepositoryProvider).fetchAllMuscles();
    state = state.copyWith(allMuscles: muscles);
    _updateTiles();
  }

  // DATA LOCAL FILTER
  void selectMuscleById(String muscleId) {
    try {
      final selectedMuscle = state.allMuscles.firstWhere((m) => m.id == muscleId);
      final filteredExercises = state.allExercises.where((e) => e.muscleId == selectedMuscle.id).toList();

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
  }
  void selectExerciseById(String exerciseId) {
    try {
      final selectedExercise = state.allExercises.firstWhere((e) => e.id == exerciseId);
      final lastSession = state.allLastSessions.firstWhere((s) => s.exerciseId == exerciseId);
      final lastSessionSummary = TrainingDataTransformer.transformSessionToSummary(
        lastSession,
        selectedExercise.name,
        state.selectedMuscle!.name,
      );

      state = state.copyWith(
        selectedExercise: selectedExercise,
        lastSession: lastSession,
        lastSessionSummary: lastSessionSummary,
      );
    
    } catch (e) {
      state = state.copyWith(
        selectedExercise: null,
        lastSession: null,
      );
      } 
    }

    ExerciseData? get selectedExercise => state.selectedExercise;
    List<MuscleTileSchema> get muscleTiles => state.muscleTiles;
    List<ExerciseTileSchema> get exerciseTiles => state.exerciseTiles;
    SessionInfoSchema? get lastSessionSummary => state.lastSessionSummary;

  // VIEW MODEL
  void _updateTiles() {
    var newMuscleTiles = TrainingDataTransformer.transformMusclesToTiles(state.allMuscles, state.lastMuscleTrainingTimes);
    var newExerciseTiles = TrainingDataTransformer.transformExercisesToTiles(state.filteredExercises, state.lastTrainingTimes);

    state = state.copyWith(
      muscleTiles: newMuscleTiles,
      exerciseTiles: newExerciseTiles,
    );
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
