import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';

class ExerciseTileSchema {
  final String exerciseId;
  final String label;
  final String imagePath;
  final int timeSinceExercise; // Days since last performed

  ExerciseTileSchema({
    required this.exerciseId,
    required this.label,
    required this.imagePath,
    required this.timeSinceExercise,
  });
}

class ExerciseTile extends StatelessWidget {
  final ExerciseTileSchema exercise;
  final bool isSelected;
  final bool isCompleted;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.isSelected = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: isSelected ? 80 : 60,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(customTheme?.properties.borderRadius ?? 0.0),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 5,
            bottom: 5,
            child: Image.asset(
              exercise.imagePath,
              width: 48,  // Specify a width for the SVG image
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75),  // Adjust left padding to give space for the image
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  exercise.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isCompleted ? theme.shadowColor : theme.primaryColorDark,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '${exercise.timeSinceExercise <365?
                      exercise.timeSinceExercise
                      : "ထ"   
                  } días',
                  
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isCompleted ? theme.shadowColor : theme.primaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
