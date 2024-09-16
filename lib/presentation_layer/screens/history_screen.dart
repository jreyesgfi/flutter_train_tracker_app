import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/slivers/filter_slivers.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/history/date_separator.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/history/session_log_card.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController _scrollController =
        ref.watch(scrollControllerProvider);
    final provider = ref.watch(reportScreenProvider);
    final List<SessionEntity> allSessions = provider.allSessions;
    final filteredSessionIds =
        provider.filteredSessions.map((s) => s.id).toSet();

    return CustomScrollView(
      controller: _scrollController, // Use the provided ScrollController
      slivers: [
        // Sticky Filter Section
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

        // Session logs and date separators as
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return buildSessionItem(
                    context, allSessions, index, filteredSessionIds);
              },
              childCount: allSessions.length,
            ),
          ),
        )
      ],
    );
  }

  // Build session items and date separators
  Widget buildSessionItem(BuildContext context, List<SessionEntity> sessions,
      int index, Set<String> filteredSessionIds) {
    final session = sessions[index];
    final bool filteredOut = !filteredSessionIds.contains(session.id);

    // Check if we need a date separator
    if (index == 0 ||
        sessions[index].timeStamp.day != sessions[index - 1].timeStamp.day) {
      return Column(
        children: [
          // Instead of Sliver here (since it's within a SliverList child)
          DateSeparator(date: session.timeStamp), // Sticky Date Separator
          SessionLogCard(session: session, filteredOut: filteredOut),
        ],
      );
    }

    // Just return the session log card if no separator is needed
    return SessionLogCard(session: session, filteredOut: filteredOut);
  }
}



class _DateSeparatorHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;

  _DateSeparatorHeaderDelegate(this.date);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Add background color for non-transparent separator
      child: DateSeparator(date: date), // Use your DateSeparator widget
    );
  }

  @override
  double get maxExtent => 60; // Define the max height for DateSeparator
  @override
  double get minExtent => 60; // Define the min height for DateSeparator

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Rebuild whenever necessary
  }
}
