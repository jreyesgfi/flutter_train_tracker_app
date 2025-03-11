// lib/features/create_training/presentation/create_training_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/data/repositories/session_repository_impl.dart';
import 'package:gymini/features/select_training/provider/select_training_notifier.dart';
import 'package:gymini/features/select_training/provider/select_training_state.dart';
import 'package:gymini/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/exercise_repository_impl.dart';
import 'package:gymini/data/repositories/local_data_repository_impl.dart';
import 'package:gymini/features/select_training/adapter/training_data_adapter.dart';

// The final provider you can use in your UI
final createTrainingProvider =
    StateNotifierProvider<SelectTrainingNotifier, SelectTrainingState>((ref) {
  // Read the repositories from their providers
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final muscleRepo = ref.watch(muscleRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  final localRepo = ref.watch(localRepositoryProvider);
  final dataTransformer = ref.watch(trainingDataAdapter);
  final sharedStreams = ref.watch(globalSharedStreamsProvider);

  return SelectTrainingNotifier(
    sessionRepository: sessionRepo,
    muscleRepository: muscleRepo,
    exerciseRepository: exerciseRepo,
    localRepository: localRepo,
    dataTransformer: dataTransformer,
    sharedStreams: sharedStreams,
  );
});
