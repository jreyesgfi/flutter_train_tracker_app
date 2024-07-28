import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/ExerciseData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDataServiceProvider = Provider<ExerciseDataService>((ref) {
  return ExerciseDataService();
});

class ExerciseDataService {
  Future<void> deleteExercise(ExerciseData exercise) async {
    try {
      final request = ModelMutations.delete(exercise);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error deleting exercise: $e');
    }
  }

  Future<List<ExerciseData>> fetchAllExercises() async {
    try {
      List<ExerciseData> exercises =
          await Amplify.DataStore.query(ExerciseData.classType);
      print("$exercises");
      return exercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }
}
