import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/count_bar_chart.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/sessions_history_calendar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ReportScreenContent();
  }
}

class _ReportScreenContent extends ConsumerStatefulWidget {
  const _ReportScreenContent({super.key});

  @override
  _ReportScreenContentState createState() => _ReportScreenContentState();
}

class _ReportScreenContentState extends ConsumerState<_ReportScreenContent>{

  @override
  void initState() {
    super.initState();
  }

  // Build the chart widgets immediately, even without data
  Widget _buildCharts() {

    // These widgets will render immediately, data will be updated automatically
    return ListView(
      children: [
        EntryTransition(position: 2, child: SessionsHistoryCalendarWidget()),
        EntryTransition(position: 3, child: TrainingCountBarChart()),
        EntryTransition(position: 4, child: TrainingCountBarChart(countMusclesTrained: true)),
        MaxMinLineChart(),
        MaxMinLineChart(repsRepresentation: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Filter section
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EntryTransition(position: 1, child: const ReportFilterSection()),
            ),
            // Primary content
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildCharts(),
            ),
          ],
        ),
      ),
    );
  }
}
