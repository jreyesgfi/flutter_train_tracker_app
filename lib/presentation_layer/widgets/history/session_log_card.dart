import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:gymini/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SessionLogCard extends ConsumerWidget {
  final SessionEntity session;
  final bool filteredOut;

  const SessionLogCard({
    super.key,
    required this.session,
    this.filteredOut = false,
  });

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

    final TextStyle valueStyle =
        theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
    final TextStyle labelStyle = theme.textTheme.bodySmall!;

    List<Widget> content = [
      Text(exercise,
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.primaryColorDark)),
      Text(muscle,
          style: theme.textTheme.titleMedium
              ?.copyWith(color: theme.primaryColorDark)),
    ];

    if (!filteredOut) {
      content.addAll([
        SizedBox(height:GyminiTheme.verticalGapUnit*2),
        Row(children: [
          const SizedBox(height: 16),
          _buildDataRow(
            iconPath: "assets/icons/weight.svg",
            value:
                "${session.minWeight.toStringAsFixed(1)} - ${session.maxWeight.toStringAsFixed(1)}",
            label: "kg",
            theme: theme,
            valueStyle: valueStyle,
            labelStyle: labelStyle,
            firstElement: true,
          ),
          const SizedBox(width: 28),
          const SizedBox(height: 12),
          _buildDataRow(
            iconPath: "assets/icons/repeat.svg",
            value: "${session.minReps} - ${session.maxReps}",
            label: "reps",
            theme: theme,
            valueStyle: valueStyle,
            labelStyle: labelStyle,
            firstElement: false,
          ),
        ]),
      ]);
    }

    return Opacity(
      opacity: filteredOut ? 0.5 : 1.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 600), // Set your maximum width here
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
    required bool firstElement,
  }) {
    final color =
        firstElement ? AppColors.primaryColor : AppColors.secondaryColor;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 4),
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 4),
          Text(value, style: valueStyle),
          const SizedBox(width: 4),
          Text(label, style: labelStyle),
        ],
    );
  }
}
