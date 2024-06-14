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
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 4),
          Text(
            sessionInfo.muscleGroup,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '${sessionInfo.timeSinceLastSession} days ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          CustomSlider(min: sessionInfo.minReps, max: sessionInfo.maxReps),
          SizedBox(height: 8),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Min Weight'),
                  Text('${sessionInfo.minWeight} kg'),
                ],
              ),
              Column(
                children: [
                  Text('Max Weight'),
                  Text('${sessionInfo.maxWeight} kg'),
                ],
              ),
              CustomSlider(min: sessionInfo.minWeight, max: sessionInfo.maxWeight)
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Min Reps'),
                  Text('${sessionInfo.minReps}'),
                ],
              ),
              Column(
                children: [
                  Text('Max Reps'),
                  Text('${sessionInfo.maxReps}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}