import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart' as domain;
import 'package:flutter_application_test1/domain_layer/repositories/cloud_repository_interfaces.dart';
import 'package:flutter_application_test1/infrastructure_layer/network/session_data_service.dart';
import 'package:flutter_application_test1/models/SessionData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final sessionService = ref.read(sessionDataServiceProvider);
  return SessionRepositoryImpl(sessionService);
});

class SessionRepositoryImpl implements SessionRepository {
  final SessionDataService sessionService;

  SessionRepositoryImpl(this.sessionService);

  @override
  Future<List<domain.SessionEntity>> fetchLastSessions(List<String> exerciseIds) async {
    List<SessionData?> sessionDataList = await sessionService.fetchLastSessions(exerciseIds);
    List<SessionData> nonNullSessionDataList = sessionDataList.whereType<SessionData>().toList();

    return nonNullSessionDataList.map((sessionData) {
      // Convert SessionData from API to domain entity SessionData
      return domain.SessionEntity(
        id: sessionData.sessionId,
        exerciseId: sessionData.exerciseId,
        muscleId: sessionData.muscleId,
        timeStamp: sessionData.timeStamp.getDateTime(),
        maxWeight: sessionData.maxWeight ?? 10,
        minWeight: sessionData.minWeight ?? 10, 
        maxReps: sessionData.maxReps ?? 10,
        minReps: sessionData.minReps ?? 10,
      );
    }).toList();
  }
  @override
  Future<List<domain.SessionEntity>> fetchAllSessions() async{
    List<SessionData?> sessionDataList = await sessionService.fetchAllSessions();
    List<SessionData> nonNullSessionDataList = sessionDataList.whereType<SessionData>().toList();

    return nonNullSessionDataList.map((sessionData) {
      // Convert SessionData from API to domain entity SessionData
      return domain.SessionEntity(
        id: sessionData.sessionId,
        exerciseId: sessionData.exerciseId,
        muscleId: sessionData.muscleId,
        timeStamp: sessionData.timeStamp.getDateTime(),
        maxWeight: sessionData.maxWeight ?? 10,
        minWeight: sessionData.minWeight ?? 10, 
        maxReps: sessionData.maxReps ?? 10,
        minReps: sessionData.minReps ?? 10,
      );
    }).toList();
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
    await sessionService.createNewSession(sessionData);
  }
}
