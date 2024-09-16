import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/slivers/filter_slivers.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/count_bar_chart.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/sessions_history_calendar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/providers/scroll_controller_provider.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController _scrollController = ref.watch(scrollControllerProvider);

    final List<Widget> elements = [
      EntryTransition(
        position: 2,
        totalAnimations: 6,
        child: SessionsHistoryCalendarWidget(),
      ),
      EntryTransition(
        position: 3,
        totalAnimations: 6,
        child: TrainingCountBarChart(),
      ),
      EntryTransition(
        position: 4,
        totalAnimations: 6,
        child: TrainingCountBarChart(countMusclesTrained: true),
      ),
      EntryTransition(
        position: 5,
        totalAnimations: 6,
        child: MaxMinLineChart(),
      ),
      EntryTransition(
        position: 6,
        totalAnimations: 6,
        child: MaxMinLineChart(repsRepresentation: true),
      ),
    ];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding:
              EdgeInsets.symmetric(
                vertical: GyminiTheme.verticalGapUnit*2,
                horizontal: GyminiTheme.leftOuterPadding
              ),
          sliver: SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverFilterHeaderDelegate(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return elements[index];
              },
              childCount: elements.length,
            ),
          ),
        ),
      ],
    );
  }
}
