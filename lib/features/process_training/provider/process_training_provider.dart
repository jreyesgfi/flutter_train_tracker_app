// lib/features/process_training/provider/process_training_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/data/repositories/local_data_repository_impl.dart';
import 'package:gymini/data/repositories/session_repository_impl.dart';
import 'package:gymini/features/process_training/provider/process_training_notifier.dart';
import 'package:gymini/features/process_training/provider/process_training_state.dart';

final processTrainingProvider = StateNotifierProvider<ProcessTrainingNotifier, ProcessTrainingState>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final localRepo = ref.watch(localRepositoryProvider);
  final globalStreams = ref.watch(globalSharedStreamsProvider);
  
  return ProcessTrainingNotifier(
    sessionRepository: sessionRepo,
    localRepository: localRepo,
    sharedStreams: globalStreams,
  );
});
