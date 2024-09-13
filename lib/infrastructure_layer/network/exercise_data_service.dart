import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/ExerciseData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDataServiceProvider = Provider<ExerciseDataService>((ref) {
  return ExerciseDataService();
});

class ExerciseDataService {
  // Future<void> deleteExercise(ExerciseData exercise) async {
  //   try {
  //     final request = ModelMutations.delete(exercise);
  //     await Amplify.API.mutate(request: request).response;
  //   } catch (e) {
  //     print('Error deleting exercise: $e');
  //   }
  // }

  // Future<List<ExerciseData>> fetchAllExercises() async {
  //   final request = ModelQueries.list(ExerciseData.classType);
  //   final response = await Amplify.API.query(request: request).response;

  //   if (response.data?.items == null) {
  //     print('fetchAllExercises errors: ${response.errors}');
  //     return [];
  //   }

  //   List<ExerciseData> newExercises = [];
  //   for (var item in response.data!.items) {
  //     if (item is ExerciseData) {
  //       // Create a new exercise with a new ID
  //       var newExercise = ExerciseData(
  //         exerciseId: item.exerciseId.replaceAll('_', ''),  // Generate a new ID
  //         name: item.name,
  //         muscleId: item.muscleId
  //         // Copy other fields if necessary
  //       );
  //       newExercises.add(newExercise);
  //       await Amplify.DataStore.save(newExercise);
  //     }
  //   }
  //   return newExercises;
  // }

  Future<List<ExerciseData>> fetchAllExercises() async {
    try {
      List<ExerciseData> exercises =
          await Amplify.DataStore.query(ExerciseData.classType);
      return exercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }
}
