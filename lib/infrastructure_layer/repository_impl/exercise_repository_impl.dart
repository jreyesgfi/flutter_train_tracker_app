import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/domain_layer/repositories/cloud_repository_interfaces.dart';
import 'package:flutter_application_test1/infrastructure_layer/network/exercise_data_service.dart';
import 'package:flutter_application_test1/models/ExerciseData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final exerciseService = ref.read(exerciseDataServiceProvider);
  return ExerciseRepositoryImpl(exerciseService);
});

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseDataService exerciseService;

  ExerciseRepositoryImpl(this.exerciseService);

  @override
  Future<List<ExerciseEntity>> fetchAllExercises() async {
    List<ExerciseData> exerciseDataList = await exerciseService.fetchAllExercises();
    return exerciseDataList.map((exerciseData) {
      return ExerciseEntity(
        id: exerciseData.exerciseId,
        name: exerciseData.name,
        muscleId: exerciseData.muscleId,
      );
    }).toList();
  }
}
