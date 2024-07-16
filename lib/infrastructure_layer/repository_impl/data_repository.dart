import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_application_test1/models/MuscleData.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart' as domain;

class RealDataRepository {
  Future<List<domain.MuscleData>> fetchAllMuscles() async {
    try {
      // Create a request to list all MuscleData items
      final request = ModelQueries.list(MuscleData.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        print('errors: ${response.errors}');
        return [];
      }

      // Map the fetched models to the domain entities
      return response.data!.items.map((muscleData) {
        return domain.MuscleData(
          id: muscleData!.muscleId,
          name: muscleData.name,
        );
      }).toList();
    } on ApiException catch (e) {
      print('Query failed: $e');
      return [];
    }
  }
}
