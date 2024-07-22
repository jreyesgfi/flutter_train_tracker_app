import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/ExerciseData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDataServiceProvider = Provider<ExerciseDataService>((ref) {
  return ExerciseDataService();
});

class ExerciseDataService {
  Future<List<ExerciseData>> fetchAllExercises() async {
    final request = ModelQueries.list(ExerciseData.classType);
    final response = await Amplify.API.query(request: request).response;

    if (response.data?.items == null) {
      print('fetchAllExercises errors: ${response.errors}');
      return [];
    }

    List<ExerciseData> exercises = [];
    for (var item in response.data!.items) {
      if (item is ExerciseData) {
        exercises.add(item);
      }
    }
    return exercises;
  }
}
