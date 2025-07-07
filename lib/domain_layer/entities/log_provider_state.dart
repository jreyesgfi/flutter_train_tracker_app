import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';

abstract class SessionLogProviderState {
  LogFilter get logFilter;
  List<SessionEntity> get filteredSessions;
}

abstract class SessionLogGrainedProviderState extends SessionLogProviderState {
  List<SessionEntity> get filteredSessionsByDate;
}