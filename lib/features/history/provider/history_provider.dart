// lib/features/history/provider/history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/data/repositories/local_data_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/exercise_repository_impl.dart';
import 'package:gymini/data/repositories/session_repository_impl.dart';
import 'package:gymini/features/history/provider/history_notifier.dart';
import 'package:gymini/features/history/provider/history_state.dart';

// If you already have a local repository provider, import it;
// Otherwise, use a dummy if not needed.
final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final muscleRepo = ref.watch(muscleRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final globalStreams = ref.watch(globalSharedStreamsProvider);
  // Use the real local repository if needed
  final localRepo = ref.watch(localRepositoryProvider);
  return HistoryNotifier(
    muscleRepository: muscleRepo,
    exerciseRepository: exerciseRepo,
    sessionRepository: sessionRepo,
    localRepository: localRepo,
    sharedStreams: globalStreams,
  );
});
