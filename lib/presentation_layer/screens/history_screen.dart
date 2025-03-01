import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/presentation_layer/providers/report_screen_provider.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/presentation_layer/widgets/common/slivers/filter_slivers.dart';
import 'package:gymini/presentation_layer/widgets/history/date_separator.dart';
import 'package:gymini/presentation_layer/widgets/history/session_log_card.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController =
        ref.watch(scrollControllerProvider);
    final provider = ref.watch(reportScreenProvider);
    final List<SessionEntity> allSessions = provider.allSessions;
    final filteredSessionIds =
        provider.filteredSessions.map((s) => s.id).toSet();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Sticky Filter Section at the top
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

        // Create date sections for each date group
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: MultiSliver(children: [
            ...buildDateSections(allSessions, filteredSessionIds)
          ]),
        ),
      ],
    );
  }

  // Generate the date sections using DateSection widget
  List<Widget> buildDateSections(
      List<SessionEntity> sessions, Set<String> filteredSessionIds) {
    List<Widget> dateSections = [];
    DateTime? currentDate;
    List<Widget> itemsForCurrentDate = [];

    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      final bool filteredOut = !filteredSessionIds.contains(session.id);

      // If the date changes or this is the first session, finalize the previous section and start a new one
      if (currentDate == null || session.timeStamp.day != currentDate.day) {
        if (itemsForCurrentDate.isNotEmpty) {
          // Finalize the previous section
          dateSections.add(
            DateSection(
              dateStamp: currentDate!,
              items: itemsForCurrentDate,
            ),
          );
          itemsForCurrentDate = [];
        }

        // Start a new date section
        currentDate = session.timeStamp;
      }

      // Add the session to the current date's section
      itemsForCurrentDate.add(
        EntryTransition(
            position: i % 8 + 2,
            totalAnimations: 10,
            child: SessionLogCard(session: session, filteredOut: filteredOut)),
      );
    }

    // Don't forget the last section
    if (itemsForCurrentDate.isNotEmpty && currentDate != null) {
      dateSections.add(
        DateSection(
          dateStamp: currentDate,
          items: itemsForCurrentDate,
        ),
      );
    }

    return dateSections;
  }
}

// DateSection to handle date-based grouping of logs
class DateSection extends MultiSliver {
  DateSection({
    super.key,
    required DateTime dateStamp,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Container(
                color: AppColors.screenBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: EntryTransition(
                    position: 2,
                    totalAnimations: 10,
                    child: DateSeparator(date: dateStamp)),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}
