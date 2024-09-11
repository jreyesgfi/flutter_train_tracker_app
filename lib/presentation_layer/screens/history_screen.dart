import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/history/date_separator.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/history/session_log_card.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _HistoryScreenContent();
  }
}

class _HistoryScreenContent extends ConsumerStatefulWidget {
  const _HistoryScreenContent({super.key});

  @override
  _HistoryScreenContentState createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends ConsumerState<_HistoryScreenContent> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(reportScreenProvider);
    final List<SessionEntity> allSessions = provider.allSessions;
    final filteredSessionIds = provider.filteredSessions.map((s) => s.id).toSet();
    final items = buildItems(allSessions, filteredSessionIds);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const EntryTransition(position: 1, child: ReportFilterSection(), totalAnimations: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildItems(List<SessionEntity> sessions, Set<String> filteredSessionIds) {
    List<Widget> items = [];
    DateTime? currentDate;

    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      final bool filteredOut = !filteredSessionIds.contains(session.id);

      if (currentDate == null || session.timeStamp.day != currentDate.day) {
        if (currentDate != null) {
          items.add(
            const SizedBox(height: 16)
            );// Optional spacing between sections
        }
        items.add(EntryTransition(
          position: items.length%9 + 1,
          child: DateSeparator(date: session.timeStamp),
          totalAnimations: 10,
        ));
      }

      items.add(EntryTransition(
        position: items.length%9 + 1,
        child: SessionLogCard(session: session, filteredOut: filteredOut),
        totalAnimations: 10,
      ));

      currentDate = session.timeStamp;
    }

    return items;
  }
}
