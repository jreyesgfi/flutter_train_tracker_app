import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/custom_slider.dart';

class PreviousSessionInfoSchema {
  final String exerciseName;
  final String muscleGroup;
  final int timeSinceLastSession; // in days
  final int minWeight;
  final int maxWeight;
  final int minReps;
  final int maxReps;

  PreviousSessionInfoSchema({
    required this.exerciseName,
    required this.muscleGroup,
    required this.timeSinceLastSession,
    required this.minWeight,
    required this.maxWeight,
    required this.minReps,
    required this.maxReps,
  });
}

class SessionInfoWidget extends StatelessWidget {
  final PreviousSessionInfoSchema sessionInfo;

  const SessionInfoWidget({
    super.key,
    required this.sessionInfo
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sessionInfo.exerciseName,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 4),
          Text(
            sessionInfo.muscleGroup,
            style: theme.textTheme.titleMedium,
          ),
          Text(
            '${sessionInfo.timeSinceLastSession} days ago',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.shadowColor),
          ),
          // Weights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesos', style: theme.textTheme.bodyMedium),
              Align(
                alignment: Alignment.centerRight,
                child: InfoChartLastTrain(
                  minVal: sessionInfo.minWeight,
                  maxVal: sessionInfo.maxWeight),
              ),
            ],
          ),
          // Reps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reps', style: theme.textTheme.bodyMedium),
              Align(
                alignment: Alignment.centerRight,
                child:  InfoChartLastTrain(
                  minVal: sessionInfo.minReps,
                  maxVal: sessionInfo.maxReps,
                  right: false,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
