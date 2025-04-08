// lib/features/report/ui/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/presentation_layer/widgets/reporting/count_bar_chart.dart';
import 'package:gymini/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/presentation_layer/widgets/common/slivers/filter_slivers.dart';
import 'package:gymini/presentation_layer/widgets/reporting/sessions_history_calendar_widget.dart';

// Updated widget imports (adjust paths as needed)

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ref.watch(scrollControllerProvider);
    // // Optionally, read your report state:
    // final reportState = ref.watch(reportProvider);

    // Build the list of report widgets.
    final List<Widget> elements = [
      const EntryTransition(
        position: 2,
        totalAnimations: 6,
        child: SessionsHistoryCalendarWidget(),
      ),
      EntryTransition(
        position: 3,
        totalAnimations: 6,
        child: TrainingCountBarChart(),  // This widget will read reportProvider internally.
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
      controller: scrollController,
      slivers: [
        // A pinned filter header (using your SliverFilterHeaderDelegate).
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: GyminiTheme.verticalGapUnit * 2,
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverFilterHeaderDelegate(),
          ),
        ),
        // The main content displaying each report element.
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => elements[index],
              childCount: elements.length,
            ),
          ),
        ),
      ],
    );
  }
}
