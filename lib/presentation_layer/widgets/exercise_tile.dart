import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExerciseTileSchema {
  final String label;
  final String imagePath;
  final int timeSinceExercise; // Days since last performed

  ExerciseTileSchema({
    required this.label,
    required this.imagePath,
    required this.timeSinceExercise,
  });
}

class ExerciseTile extends StatelessWidget {
  final ExerciseTileSchema exercise;
  final bool isSelected;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
      height: isSelected ? 80 : 60,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? theme.shadowColor : theme.primaryColorLight,
        borderRadius: BorderRadius.circular(customTheme?.properties.borderRadius ?? 0.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            left: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                exercise.imagePath,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  exercise.label,
                  style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColor),
                ),
                Text(
                  '${exercise.timeSinceExercise} días',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
