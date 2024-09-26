import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gymini/models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muscleDataServiceProvider = Provider<MuscleDataService>((ref) {
  return MuscleDataService();
});

class MuscleDataService {
  //   Future<List<MuscleData>> fetchAllMuscles() async {
  //   final request = ModelQueries.list(MuscleData.classType);
  //   final response = await Amplify.API.query(request: request).response;

  //   if (response.data?.items == null) {
  //     print('fetchAllMuscles errors: ${response.errors}');
  //     return [];
  //   }

  //   List<MuscleData> newMuscles = [];
  //   for (var item in response.data!.items) {
  //     if (item is MuscleData) {
  //       // Create a new muscle with a new ID
  //       var newMuscle = MuscleData(
  //         muscleId: item.muscleId.replaceAll('_', ''),  // Generate a new ID
  //         name: item.name,
  //         // Copy other fields if necessary
  //       );
  //       newMuscles.add(newMuscle);
  //       await Amplify.DataStore.save(newMuscle);
  //     }
  //   }

  //   return newMuscles;
  // }
  Future<List<MuscleData>> fetchAllMuscles() async {
    try {
      List<MuscleData> muscles =
          await Amplify.DataStore.query(MuscleData.classType);
      return muscles;
    } catch (e) {
      print('Error fetching muscles: $e');
      return [];
    }
  }

  // Future<void> deleteMuscle(MuscleData muscle) async {
  //   try {
  //     final request = ModelMutations.delete(muscle);
  //     await Amplify.API.mutate(request: request).response;
  //   } catch (e) {
  //     print('Error deleting muscle: $e');
  //   }
  // }
}
