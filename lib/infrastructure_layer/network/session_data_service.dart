
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:gymini/models/SessionData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionDataServiceProvider = Provider<SessionDataService>((ref) {
  return SessionDataService();
});

class SessionDataService {

  
  Future<List<SessionData>> fetchLastSessions(List<String> exerciseIds) async {
    try {
      final allSessions = await Amplify.DataStore.query(SessionData.classType);
      final sessions = allSessions
          .where((session) => exerciseIds.contains(session.exerciseId))
          .toList();
      return sessions;
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  Future<List<SessionData>> fetchAllSessions() async {
    try {
      List<SessionData> sessions =
          await Amplify.DataStore.query(SessionData.classType);
      return sessions;
    } catch (e) {
      print('Error fetching sessions: $e');
      return [];
    }
  }

  Future<void> createNewSession(SessionData sessionData) async {
    try {
      await Amplify.DataStore.save(sessionData);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating new session: $e');
      }
    }
  }
}
