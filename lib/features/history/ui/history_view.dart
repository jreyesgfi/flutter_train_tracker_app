// lib/features/history/ui/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/features/history/provider/history_provider.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/common/widgets/filter/filter_slivers.dart';
import 'package:gymini/features/history/ui/widgets/date_separator.dart';
import 'package:gymini/features/history/ui/widgets/session_log_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  List<Widget> buildDateSections(
    List<SessionEntity> filteredSessions) {
    List<Widget> dateSections = [];
    DateTime? currentDate;
    List<Widget> itemsForCurrentDate = [];
    for (int i = 0; i < filteredSessions.length; i++) {

      final session = filteredSessions[i];
      const bool filteredOut = false;

      // When the day changes (or on first session) finalize previous group.
      if (currentDate == null || session.timeStamp.day != currentDate.day) {
        if (itemsForCurrentDate.isNotEmpty && currentDate != null) {
          dateSections.add(
            DateSection(
              dateStamp: currentDate,
              items: itemsForCurrentDate,
            ),
          );
          itemsForCurrentDate = [];
        }
        currentDate = session.timeStamp;
      }
      itemsForCurrentDate.add(
        EntryTransition(
          position: (i % 8) + 2,
          totalAnimations: 10,
          child: SessionLogCard(session: session, filteredOut: filteredOut),
        ),
      );
    }
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

  /// Build date sections once and return them as a list of Widgets.
  // List<Widget> buildDateSections(
  //     List<SessionEntity> sessions, Set<String> filteredSessionIds) {
  //   List<Widget> dateSections = [];
  //   DateTime? currentDate;
  //   List<Widget> itemsForCurrentDate = [];

  //   for (int i = 0; i < filteredSessionIds.length; i++) {
  //     final session = sessions[i];
  //     final bool filteredOut = !filteredSessionIds.contains(session.id);

  //     // When the day changes (or on first session) finalize previous group.
  //     if (currentDate == null || session.timeStamp.day != currentDate.day) {
  //       if (itemsForCurrentDate.isNotEmpty && currentDate != null) {
  //         dateSections.add(
  //           DateSection(
  //             dateStamp: currentDate,
  //             items: itemsForCurrentDate,
  //           ),
  //         );
  //         itemsForCurrentDate = [];
  //       }
  //       currentDate = session.timeStamp;
  //     }
  //     itemsForCurrentDate.add(
  //       EntryTransition(
  //         position: (i % 8) + 2,
  //         totalAnimations: 10,
  //         child: SessionLogCard(session: session, filteredOut: filteredOut),
  //       ),
  //     );
  //   }
  //   if (itemsForCurrentDate.isNotEmpty && currentDate != null) {
  //     dateSections.add(
  //       DateSection(
  //         dateStamp: currentDate,
  //         items: itemsForCurrentDate,
  //       ),
  //     );
  //   }
  //   return dateSections;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);
    final historyState = ref.watch(historyProvider);
    // final List<SessionEntity> allSessions = historyState.allSessions;
    // final filteredSessionIds =
    //     historyState.filteredSessions.map((s) => s.id).toSet();
    final filteredSessions = historyState.filteredSessions;

    // Build the date sections once.
    final dateSections = buildDateSections(filteredSessions);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Sticky filter header at the top.
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
        // Use a MultiSliver to merge the dateSections into a single sliver.
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: MultiSliver(
            children: dateSections,
          ),
        ),
      ],
    );
  }
}

/// DateSection groups a pinned header (with date separator) and a list of session log cards.
class DateSection extends MultiSliver {
  DateSection({
    super.key,
    required DateTime dateStamp,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            // Pinned header with a date separator.
            SliverPinnedHeader(
              child: Container(
                color: AppColors.screenBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: EntryTransition(
                  position: 2,
                  totalAnimations: 10,
                  child: DateSeparator(date: dateStamp),
                ),
              ),
            ),
            // Session log cards.
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}
