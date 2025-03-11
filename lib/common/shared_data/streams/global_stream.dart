
import 'package:gymini/common/shared_data/streams/exercise_stream_provider.dart';
import 'package:gymini/common/shared_data/streams/muscle_stream_provider.dart';
import 'package:gymini/common/shared_data/streams/session_stream_provider.dart';


/// Global container for all shared streams.
class GlobalSharedStreams {
  final SessionSharedStream sessionStream = SessionSharedStream();
  final SelectedMuscleSharedStream selectedMuscleStream = SelectedMuscleSharedStream();
  final SelectedExerciseSharedStream selectedExerciseStream = SelectedExerciseSharedStream();

  void dispose() {
    sessionStream.dispose();
    selectedMuscleStream.dispose();
    selectedExerciseStream.dispose();
  }
}