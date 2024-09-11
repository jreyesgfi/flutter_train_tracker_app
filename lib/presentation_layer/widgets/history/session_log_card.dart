import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final muscle = ref
            .read(reportScreenProvider.notifier)
            .retrieveMuscleById(session.muscleId)
            ?.name ??
        "Unknown Muscle";
    final exercise = ref
            .read(reportScreenProvider.notifier)
            .retrieveExerciseById(session.exerciseId)
            ?.name ??
        "Unknown Exercise";

    final TextStyle valueStyle = theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
    final TextStyle labelStyle = theme.textTheme.bodySmall!;

    List<Widget> content = [
      Text(exercise, style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark)),
      Text(muscle, style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColorDark)),
    ];

    if (!filteredOut) {
      content.addAll([
        SizedBox(height: 24),
        _buildDataRow(
          iconPath: "assets/icons/weight.svg",
          value: "${session.minWeight.toStringAsFixed(1)} - ${session.maxWeight.toStringAsFixed(1)}",
          label: "kg",
          theme: theme,
          valueStyle: valueStyle,
          labelStyle: labelStyle,
        ),
        SizedBox(height: 16),
        _buildDataRow(
          iconPath: "assets/icons/repeat.svg",
          value: "${session.minReps} - ${session.maxReps}",
          label: "reps",
          theme: theme,
          valueStyle: valueStyle,
          labelStyle: labelStyle,
        ),
      ]);
    }

    return Opacity(
      opacity: filteredOut ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.primaryColorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Set your maximum width here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required String iconPath,
    required String value,
    required String label,
    required ThemeData theme,
    required TextStyle valueStyle,
    required TextStyle labelStyle,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.primaryColor, width: 5)),
      ),
      padding: const EdgeInsets.only(left: 12, top:24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 4),
          SizedBox(
            width: 28,
            height: 28,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 40),
          Text(value, style: valueStyle),
          const SizedBox(width: 4),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }
}
