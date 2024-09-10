import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/history/session_log_card.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/count_bar_chart.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/sessions_history_calendar_widget.dart';
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
    final List<SessionEntity> allSessions =
        ref.watch(reportScreenProvider).filteredSessions;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const EntryTransition(position: 1, child: ReportFilterSection()),
            Expanded(
              child: ListView.builder(
                itemCount: allSessions.length,
                itemBuilder: (context, index) {
                  return SessionLogCard(session: allSessions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
