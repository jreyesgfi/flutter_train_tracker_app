
import 'package:gymini/common/shared_data/exercise_stream_provider.dart';
import 'package:gymini/common/shared_data/muscle_stream_provider.dart';
import 'package:gymini/common/shared_data/session_stream_provider.dart';


/// Global container for all shared streams.
class GlobalSharedStreams {
  final SessionSharedStream sessionStream = SessionSharedStream();
  final SelectedMuscleIdSharedStream selectedMuscleIdStream = SelectedMuscleIdSharedStream();
  final SelectedExerciseIdSharedStream selectedExerciseIdStream = SelectedExerciseIdSharedStream();

  void dispose() {
    sessionStream.dispose();
    selectedMuscleIdStream.dispose();
    selectedExerciseIdStream.dispose();
  }
}