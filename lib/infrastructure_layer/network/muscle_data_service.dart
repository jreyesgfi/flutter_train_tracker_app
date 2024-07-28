import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/MuscleData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muscleDataServiceProvider = Provider<MuscleDataService>((ref) {
  return MuscleDataService();
});

class MuscleDataService {
  Future<List<MuscleData>> fetchAllMuscles() async {
    try {
      List<MuscleData> muscles =
          await Amplify.DataStore.query(MuscleData.classType);
      print("$muscles");
      return muscles;
    } catch (e) {
      print('Error fetching muscles: $e');
      return [];
    }
  }

  Future<void> deleteMuscle(MuscleData muscle) async {
    try {
      final request = ModelMutations.delete(muscle);
      await Amplify.API.mutate(request: request).response;
    } catch (e) {
      print('Error deleting muscle: $e');
    }
  }
}
