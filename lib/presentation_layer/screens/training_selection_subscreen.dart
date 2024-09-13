import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/router/navitation_utils.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_list_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_carousel_selector.dart';

class TrainingSelectionSubscreen extends ConsumerWidget {
  TrainingSelectionSubscreen({Key? super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final providerWatch = ref.watch(trainingScreenProvider);

    final muscles = providerWatch.muscleTiles;
    final exercises = providerWatch.exerciseTiles;

    final selectedMuscle = providerWatch.selectedMuscle;
    // final selectedExercise = providerWatch.selectedExercise;
    final newSession = providerWatch.newSession;

    final exerciseSelectorKey =
        ValueKey('${selectedMuscle?.id}_${newSession?.id}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntryTransition(
            position: 2,
            child: Padding(
              padding: EdgeInsets.only(top: GyminiTheme.verticalGapUnit*2),
              child: Text(
                "¿Qué vamos a entrenar hoy?",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.primaryColorDark),
              ),
            ),
          ),

          // Display muscle carousel selector if muscles are available
          if (muscles.isNotEmpty)
            EntryTransition(
              position: 3,
              child: MuscleCarouselSelector(muscles: muscles)
              ),

          if (exercises.isNotEmpty)
            EntryTransition(
              position: 4,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
                child: Text(
                  "Escoge un ejercicio",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.primaryColorDark),
                ),
              ),
            ),

          // Display exercise list selector if exercises are available
          if (exercises.isNotEmpty)
            EntryTransition(
              position: 5,
              child: ExerciseListSelector(key: exerciseSelectorKey),
            ),
        ],
    );
  }
}
