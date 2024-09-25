import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/modals_snackbars/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'exercise_tile.dart';

class ExerciseListSelector extends ConsumerStatefulWidget {
  

  const ExerciseListSelector({
    super.key,
  });

  @override
  ConsumerState<ExerciseListSelector> createState() => _ExerciseListSelectorState();
}

class _ExerciseListSelectorState extends ConsumerState<ExerciseListSelector> {
  int? selectedIndex;
  
  @override
  Widget build(BuildContext context) {
    final providerWatch = ref.watch(trainingScreenProvider);
    final providerPost = ref.read(trainingScreenProvider.notifier);
    final List<ExerciseTileSchema> exercises = providerWatch.exerciseTiles;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          exercises.length,
          (index) {
            bool isCompleted =
                exercises[index].timeSinceExercise == 0 ? true:false;
            return GestureDetector(
                onTap: () {
                  if (isCompleted) {
                    showWarningSnackbar(
                      context: context,
                      message: "Ejercicio ya completado hoy"
                    );
                    return;
                  }
                  setState(() {
                    selectedIndex = index;
                    // completionStatus[index] = true;
                  });

                  final exercise = exercises[index];
                  providerPost.selectExerciseById(exercise.exerciseId);
                  // providerPost.nextStage();
                },
                child: Container(
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 10),
                  child: ExerciseTile(
                    exercise: exercises[index],
                    isSelected: false,
                    isCompleted: isCompleted,
                    toggleLike: ref.read(trainingScreenProvider.notifier).toggleExerciseLikeState,
                  ),
                ));
          },
        ),
      ),
    );
  }
}
