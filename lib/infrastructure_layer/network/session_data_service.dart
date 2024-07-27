import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/models/SessionData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionDataServiceProvider = Provider<SessionDataService>((ref) {
  return SessionDataService();
});

class SessionDataService {
  Future<List<SessionData?>> fetchLastSessions(List<String> exerciseIds) async {
    List<Future<SessionData?>> futures = exerciseIds.map((exerciseId) async {
      String getLastSessionQuery = '''
    query GetLastSessionByExercise(\$exerciseId: ID!) {
      getLastSessionByExercise(exerciseId: \$exerciseId) {
        sessionId
        exerciseId
        muscleId
        timeStamp
        maxWeight
        minWeight
        maxReps
        minReps
      }
    }
  ''';
      try {
        var request = GraphQLRequest<String>(
            document: getLastSessionQuery,
            variables: {'exerciseId': exerciseId});

        var operation = Amplify.API.query(request: request);
        var response = await operation.response;
        var data = jsonDecode(response.data ?? '');

        if (data['getLastSessionByExercise'] != null) {
          return SessionData.fromJson(data['getLastSessionByExercise']);
        } else {
          print('No session found for exercise $exerciseId');
          return null;
        }
      } catch (e) {
        print('Error fetching session for exercise $exerciseId: $e');
        return null;
      }
    }).toList();

    // Wait for all futures to complete
    var results = await Future.wait(futures);
    return results.whereType<SessionData>().toList();
  }

  Future<List<SessionData>> fetchAllSessions() async {
    final request = ModelQueries.list(SessionData.classType);
    final response = await Amplify.API.query(request: request).response;

    if (response.data?.items == null) {
      print('fetchAllSessions errors: ${response.errors}');
      return [];
    }

    List<SessionData> sessions = [];
    for (var item in response.data!.items) {
      if (item is SessionData) {
        sessions.add(item);
      }
    }
    return sessions;
  }

  Future<void> createNewSession(SessionData sessionData) async {
    final mutationRequest = ModelMutations.create(sessionData);
    try {
      final response =
          await Amplify.API.mutate(request: mutationRequest).response;
      if (response.hasErrors) {
        print('Error creating session: ${response.errors}');
      } else {
        print('Session created successfully');
      }
    } catch (e) {
      print('An error occurred while creating a session: $e');
    }
  }
}
