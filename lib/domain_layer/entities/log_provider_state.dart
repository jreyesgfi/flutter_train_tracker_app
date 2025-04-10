import 'package:gymini/domain_layer/entities/core_entities.dart';

abstract class SessionLogProviderState {
  int get selectedMonth;
  int get selectedYear;
  List<SessionEntity> get filteredSessions;
}

abstract class SessionLogGrainedProviderState extends SessionLogProviderState {
  List<SessionEntity> get filteredSessionsByDate;
}