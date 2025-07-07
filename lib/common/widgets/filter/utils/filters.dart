import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';

abstract class Filters{
  static List<SessionEntity> filterSessions(
    List<SessionEntity> allSession,
    LogFilter? logFilter)
    {
    final filteredSessions = allSession.where((session) {
      bool inTimeRange = true, sameMuscle = true, sameExercise = true;
      
      final start = logFilter?.timeRange?.item1 ?? DateTime.fromMillisecondsSinceEpoch(0);
      final end = logFilter?.timeRange?.item2 ?? DateTime.now();
      inTimeRange = session.timeStamp.isAfter(start) && session.timeStamp.isBefore(end);
      
      if (logFilter?.musclePicked?.id.isNotEmpty == true) {
        sameMuscle = (session.muscleId == logFilter!.musclePicked!.id);
      }
      
      if (logFilter?.musclePicked?.id.isNotEmpty == true) {
        sameExercise = (session.exerciseId == logFilter!.exercisePicked!.id);
      }
      
      return inTimeRange && sameMuscle && sameExercise;
    }).toList();
    
    return filteredSessions;
  }
}