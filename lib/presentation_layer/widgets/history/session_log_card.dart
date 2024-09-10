import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionLogCard extends ConsumerWidget {
  final SessionEntity session;
  final bool filteredOut;

  const SessionLogCard({
    Key? key,
    required this.session,
    this.filteredOut = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muscle = ref.read(reportScreenProvider.notifier).retrieveMuscleById(session.muscleId)?.name ?? "Unknown Muscle";
    final exercise = ref.read(reportScreenProvider.notifier).retrieveExerciseById(session.exerciseId)?.name ?? "Unknown Exercise";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: filteredOut ? theme.primaryColorDark : theme.primaryColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exercise: $exercise", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Muscle: $muscle", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Date: ${session.timeStamp}", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Max Weight: ${session.maxWeight} kg", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Min Weight: ${session.minWeight} kg", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Max Reps: ${session.maxReps}", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
          Text("Min Reps: ${session.minReps}", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
        ],
      ),
    );
  }
}
