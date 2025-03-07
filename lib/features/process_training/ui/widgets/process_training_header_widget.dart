import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_step_widget.dart';

class ProcessTrainingHeaderWidget extends StatelessWidget {
  final String sessionSummary;
  final int currentStage;

  const ProcessTrainingHeaderWidget({
    super.key,
    required this.sessionSummary,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: GyminiTheme.verticalGapUnit * 2,
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        sessionSummary,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Muscle Group", // Replace with dynamic data if available.
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '0 days ago', // Replace with dynamic value if available.
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.shadowColor),
                    ),
                  ],
                ),
                SessionStepWidget(
                  currentStep: (currentStage / 2).abs().round(),
                  totalSteps: 4,
                ),
              ],
            ),
          ),
        );
  }

}