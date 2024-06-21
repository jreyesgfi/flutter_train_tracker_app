import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/custom_slider.dart';



class SessionInfoWidget extends StatelessWidget {
  final SessionInfoSchema sessionInfo;

  const SessionInfoWidget({
    super.key,
    required this.sessionInfo
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  minVal: sessionInfo.minReps.toDouble(),
                  maxVal: sessionInfo.maxReps.toDouble(),
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
