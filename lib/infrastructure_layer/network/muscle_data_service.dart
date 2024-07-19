import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/MuscleData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muscleDataServiceProvider = Provider<MuscleDataService>((ref) {
  return MuscleDataService();
});

class MuscleDataService {
  Future<List<MuscleData>> fetchAllMuscles() async {
    final request = ModelQueries.list(MuscleData.classType);
    final response = await Amplify.API.query(request: request).response;

    if (response.data?.items == null) {
      print('fetchAllMuscles errors: ${response.errors}');
      return [];
    }

    // Safely cast each item to MuscleData
    List<MuscleData> muscles = [];
    for (var item in response.data!.items) {
      if (item is MuscleData) {
        muscles.add(item);
      }
    }
    return muscles;
  }
}
