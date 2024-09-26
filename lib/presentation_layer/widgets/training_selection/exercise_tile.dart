import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/widgets/common/buttons/like_button.dart';

class ExerciseTileSchema {
  final String exerciseId;
  final String label;
  final String imagePath;
  final int timeSinceExercise; // Days since last performed
  final bool liked;

  ExerciseTileSchema({
    required this.exerciseId,
    required this.label,
    required this.imagePath,
    required this.timeSinceExercise,
    required this.liked,
  });
}

class ExerciseTile extends StatelessWidget {
  final ExerciseTileSchema exercise;
  final bool isSelected;
  final bool isCompleted;
  final Function toggleLike;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.isSelected = false,
    this.isCompleted = false,
    required this.toggleLike,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: isSelected ? 1120 : 100,
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
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
                  width: 30,
                  height: 30,
                  right: 5,
                  bottom: 5,
                  child:LikeButton(
                    isLiked: exercise.liked, // This should come from your state management
                    onLike: () {
                      toggleLike(exercise.exerciseId);
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 120),  // Adjust left padding to give space for the image
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
