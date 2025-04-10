import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_step_widget.dart';

class ProcessTrainingHeaderWidget extends StatelessWidget {
  final SessionTile sessionTile;
  final int currentStage;

  const ProcessTrainingHeaderWidget({
    super.key,
    required this.sessionTile,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: Text(
                      sessionTile.exerciseName, 
                      style: theme.textTheme.titleSmall,
                      softWrap: true,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    Text(
                      sessionTile.muscleGroup, 
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${sessionTile.timeSinceLastSession == 0?"∞": sessionTile.timeSinceLastSession} days ago",
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