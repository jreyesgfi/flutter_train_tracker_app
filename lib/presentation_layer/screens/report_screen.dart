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

class _ReportScreenContentState extends ConsumerState<_ReportScreenContent> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
      const EntryTransition(position: 1,totalAnimations: 6, child: FilterSection()),
      EntryTransition(position: 2,totalAnimations: 6, child: SessionsHistoryCalendarWidget()),
      EntryTransition(position: 3,totalAnimations: 6, child: TrainingCountBarChart()),
      EntryTransition(
          position: 4,totalAnimations: 6, child: TrainingCountBarChart(countMusclesTrained: true)),
       EntryTransition(position: 5,totalAnimations: 6, child: MaxMinLineChart()),
      EntryTransition(position: 6,totalAnimations: 6, child: MaxMinLineChart(repsRepresentation: true)),
    ]);
  }
}
