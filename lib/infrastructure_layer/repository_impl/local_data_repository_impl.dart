import 'package:flutter_application_test1/domain_layer/repositories/local_repository_interfaces.dart';
import 'package:flutter_application_test1/infrastructure_layer/network/local_data_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final localRepositoryProvider = Provider<LocalRepositoryImpl>((ref) {
  final localDataService = LocalDataService();
  return LocalRepositoryImpl(localDataService);
});

class LocalRepositoryImpl implements LocalRepository
 {
  final LocalDataService localDataService;

  LocalRepositoryImpl(this.localDataService);

  @override
  Future<List<String>> getLikedMuscles() async {
    return await localDataService.getLikedMuscles();
  }

  @override
  Future<List<String>> getLikedExercises() async {
    return await localDataService.getLikedExercises();
  }

  @override
  Future<void> toggleMuscleLikeState(String muscleId) async {
    await localDataService.toggleMuscleLikeState(muscleId);
  }

  @override
  Future<void> toggleExerciseLikeState(String exerciseId) async {
    await localDataService.toggleExerciseLikeState(exerciseId);
  }
}
