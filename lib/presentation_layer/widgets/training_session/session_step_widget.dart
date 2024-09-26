import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';

class SessionStepWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SessionStepWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(
              customTheme?.properties.borderRadius ?? 0.0),
        ),
        child: Text(
          '$currentStep/$totalSteps',
          style: theme.textTheme.titleSmall
        ),
      ),
    );
  }
}
