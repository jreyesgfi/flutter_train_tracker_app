import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart' as domain;
import 'package:gymini/domain_layer/repositories/cloud_repository_interfaces.dart';
import 'package:gymini/infrastructure_layer/network/session_data_service.dart';
import 'package:gymini/models/SessionData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final sessionService = ref.read(sessionDataServiceProvider);
  return SessionRepositoryImpl(sessionService);
});

class SessionRepositoryImpl implements SessionRepository {
  final SessionDataService sessionService;

  // Cached list for locally holding session data
  List<domain.SessionEntity> _cachedSessions = [];

  // Maps for partitioning sessions by muscleId and exerciseId
  final Map<String, List<int>> _muscleMapSessions = {};
  Map<String, List<int>> _exerciseMapSessions = {};

  SessionRepositoryImpl(this.sessionService);

  @override
  Future<List<domain.SessionEntity>> fetchAllSessions() async {
    // Fetch raw session data from the service
    List<SessionData?> sessionDataList = await sessionService.fetchAllSessions();
    List<SessionData> nonNullSessionDataList = sessionDataList.whereType<SessionData>().toList();

    // Convert to domain entities and cache
    _cachedSessions = nonNullSessionDataList.map((sessionData) {
      return domain.SessionEntity(
        id: sessionData.sessionId,
        exerciseId: sessionData.exerciseId,
        muscleId: sessionData.muscleId,
        timeStamp: sessionData.timeStamp.getDateTime(),
        maxWeight: sessionData.maxWeight ?? 0,
        minWeight: sessionData.minWeight ?? 0,
        maxReps: sessionData.maxReps ?? 0,
        minReps: sessionData.minReps ?? 0,
      );
    }).toList();

    // Sort the sessions by timestamp in descending order
    _cachedSessions.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

    // Create partitioning maps
    _createPartitionMaps();

    return _cachedSessions;
  }

  void _createPartitionMaps() {
    _muscleMapSessions.clear();
    _exerciseMapSessions.clear();

    for (int i = 0; i < _cachedSessions.length; i++) {
      final session = _cachedSessions[i];

      // Group by muscleId
      if (!_muscleMapSessions.containsKey(session.muscleId)) {
        _muscleMapSessions[session.muscleId] = [];
      }
      _muscleMapSessions[session.muscleId]!.add(i);

      // Group by exerciseId
      if (!_exerciseMapSessions.containsKey(session.exerciseId)) {
        _exerciseMapSessions[session.exerciseId] = [];
      }
      _exerciseMapSessions[session.exerciseId]!.add(i);
    }
  }

  /// Retrieve the most recent sessions for a list of muscle IDs
  Future<List<domain.SessionEntity>> fetchLastSessionsByMuscleIds(List<String> muscleIds) async {
    final List<domain.SessionEntity> results = [];

    for (var muscleId in muscleIds) {
      if (_muscleMapSessions.containsKey(muscleId)) {
        final firstIndex = _muscleMapSessions[muscleId]!.first;
        results.add(_cachedSessions[firstIndex]);
      }
    }

    return results;
  }

  /// Retrieve the most recent sessions for a list of exercise IDs
  Future<List<domain.SessionEntity>> fetchLastSessionsByExerciseIds(List<String> exerciseIds) async {
    final List<domain.SessionEntity> results = [];

    for (var exerciseId in exerciseIds) {
      if (_exerciseMapSessions.containsKey(exerciseId)) {
        final firstIndex = _exerciseMapSessions[exerciseId]!.first;
        results.add(_cachedSessions[firstIndex]);
      }
    }

    return results;
  }

  /// Retrieve all the sessions associated with a specific muscle ID
  Future<List<domain.SessionEntity>> fetchSessionsByMuscleId(String muscleId) async {
    if (!_muscleMapSessions.containsKey(muscleId)) {
      return [];
    }
    return _muscleMapSessions[muscleId]!.map((index) => _cachedSessions[index]).toList();
  }

  /// Retrieve all the sessions associated with a specific exercise ID
  Future<List<domain.SessionEntity>> fetchSessionsByExerciseId(String exerciseId) async {
    if (!_exerciseMapSessions.containsKey(exerciseId)) {
      return [];
    }
    return _exerciseMapSessions[exerciseId]!.map((index) => _cachedSessions[index]).toList();
  }

  @override
  Future<void> createNewSession(domain.SessionEntity sessionEntity) async {
    SessionData sessionData = SessionData(
      sessionId: sessionEntity.id,
      exerciseId: sessionEntity.exerciseId,
      muscleId: sessionEntity.muscleId,
      timeStamp: TemporalDate(sessionEntity.timeStamp),
      maxWeight: sessionEntity.maxWeight,
      minWeight: sessionEntity.minWeight,
      maxReps: sessionEntity.maxReps,
      minReps: sessionEntity.minReps,
    );

    // Save the new session via the service
    await sessionService.createNewSession(sessionData);

    // Add to cached list and re-sort
    _cachedSessions.add(sessionEntity);
    _cachedSessions.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

    // Update the partitioning maps
    _createPartitionMaps();
  }
}