// lib/features/report/provider/report_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/features/report/provider/report_notifier.dart';
import 'package:gymini/features/report/provider/report_state.dart';
import 'package:gymini/data/repositories/local_repository_interfaces.dart';
import 'package:gymini/infrastructure_layer/repository_impl/muscle_repository_impl.dart';
import 'package:gymini/infrastructure_layer/repository_impl/exercise_repository_impl.dart';
import 'package:gymini/data/repositories/session_repository_impl.dart';

final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  final muscleRepo = ref.watch(muscleRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  // final localRepo = ref.watch(localRepositoryProvider);

  return ReportNotifier(
    muscleRepository: muscleRepo,
    exerciseRepository: exerciseRepo,
    sessionRepository: sessionRepo,
    localRepository: /* localRepo or a dummy if not used */ DummyLocalRepo(),
  );
});

class DummyLocalRepo implements LocalRepository {
  @override
  Future<List<String>> getLikedExercises() async => [];
  @override
  Future<List<String>> getLikedMuscles() async => [];
  @override
  Future<void> toggleExerciseLikeState(String exerciseId) async {}
  @override
  Future<void> toggleMuscleLikeState(String muscleId) async {}
}
