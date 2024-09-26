import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/domain_layer/entities/session_info.dart';
import 'package:gymini/presentation_layer/widgets/common/other/custom_slider.dart';



class SessionInfoWidget extends StatelessWidget {
  final SessionInfoSchema sessionInfo;

  const SessionInfoWidget({
    super.key,
    required this.sessionInfo
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<double> values = [
      sessionInfo.minReps.toDouble(),
      sessionInfo.maxReps.toDouble(),
      sessionInfo.minWeight,
      sessionInfo.maxWeight
    ];

    List<double> valuesSorted = List.from(
      values.toSet())..sort();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
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
                  maxVal: sessionInfo.maxWeight,
                  initialIndex: valuesSorted.indexOf(sessionInfo.minWeight),
                  lastIndex: valuesSorted.indexOf(sessionInfo.maxWeight)),   
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
                  initialIndex: valuesSorted.indexOf(sessionInfo.minReps.toDouble()),
                  lastIndex: valuesSorted.indexOf(sessionInfo.maxReps.toDouble()),
                  decimal: false,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
