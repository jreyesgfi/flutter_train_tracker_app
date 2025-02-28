import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart' as domain;
import 'package:gymini/data/repositories/cloud_repository_interfaces.dart';
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
  // final List<domain.MuscleEntity> _muscleList = [];
  // final List<domain.ExerciseEntity> _exerciseList = [];
  final Map<String, List<int>> _muscleMapSessions = {};
  // final Map<String, List<domain.ExerciseEntity>> _muscleMapExercises = {};
  final Map<String, List<int>> _exerciseMapSessions = {};
  final Map<String, domain.SessionEntity> _lastSessionByMuscleIds = {};
  final Map<String, domain.SessionEntity> _lastSessionByExerciseIds = {};

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
    _defineFirstSessions();

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

  void _defineFirstSessions() {
    _lastSessionByMuscleIds.clear();
    _lastSessionByExerciseIds.clear();

    // Define the last session for each muscleId
    for (var entry in _muscleMapSessions.entries) {
      final muscleId = entry.key;
      final firstIndex = entry.value.first;
      _lastSessionByMuscleIds[muscleId] = _cachedSessions[firstIndex];
    }

    // Define the last session for each exerciseId
    for (var entry in _exerciseMapSessions.entries) {
      final exerciseId = entry.key;
      final firstIndex = entry.value.first;
      _lastSessionByExerciseIds[exerciseId] = _cachedSessions[firstIndex];
    }
  }

  /// Retrieve the most recent sessions for a list of muscle IDs
  // @override
  // Future<Map<String, domain.SessionEntity>> fetchLastSessionsByMuscleIds() async {
  // return Map.from(_lastSessionByMuscleIds); // Return a copy
  // }

  /// Retrieve the most recent sessions for a list of exercise IDs
  // @override
  // Future<Map<String, domain.SessionEntity>> fetchLastSessionsByExerciseIds() async {
  //   return Map.from(_lastSessionByExerciseIds); // Return a copy
  // }

  /// Retrieve all the sessions associated with a specific muscle ID
  @override
  Future<List<domain.SessionEntity>> fetchSessionsByMuscleId(String muscleId) async {
    if (!_muscleMapSessions.containsKey(muscleId)) {
      return [];
    }
    return _muscleMapSessions[muscleId]!.map((index) => _cachedSessions[index]).toList();
  }

  /// Retrieve all the sessions associated with a specific exercise ID
  @override
  Future<List<domain.SessionEntity>> fetchSessionsByExerciseId(String exerciseId) async {
    if (!_exerciseMapSessions.containsKey(exerciseId)) {
      return [];
    }
    return _exerciseMapSessions[exerciseId]!.map((index) => _cachedSessions[index]).toList();
  }

  /// Retrieve the last session associated with a specific muscle ID
  Future<domain.SessionEntity?> fetchLastSessionByMuscleId(String muscleId) async {
    if (!_muscleMapSessions.containsKey(muscleId)) {
      return null;
    }
    final lastIndex = _muscleMapSessions[muscleId]!.first;
    return _cachedSessions[lastIndex];
  }

  /// Retrieve the last session associated with a specific exercise ID
  Future<domain.SessionEntity?> fetchLastSessionByExerciseId(String exerciseId) async {
    if (!_exerciseMapSessions.containsKey(exerciseId)) {
      return null;
    }
    final lastIndex = _exerciseMapSessions[exerciseId]!.first;
    return _cachedSessions[lastIndex];
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