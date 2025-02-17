import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/router/navitation_utils.dart';
import 'package:gymini/presentation_layer/router/routes.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:gymini/presentation_layer/providers/training_screen_provider.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_list_selector.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_carousel_selector.dart';

class TrainingSelectionSubscreen extends ConsumerWidget {
  TrainingSelectionSubscreen({Key? super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final ScrollController _scrollController =
        ref.watch(scrollControllerProvider);
    final providerWatch = ref.watch(trainingScreenProvider);

    final muscles = providerWatch.muscleTiles;
    final exercises = providerWatch.exerciseTiles;

    final selectedMuscle = providerWatch.selectedMuscle;
    // final selectedExercise = providerWatch.selectedExercise;
    final newSession = providerWatch.newSession;

    final exerciseSelectorKey =
        ValueKey('${selectedMuscle?.id}_${newSession?.id}');

    return CustomScrollView(
      controller: _scrollController, // Use shared ScrollController
      slivers: [
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver:
              // Sliver list for the content of the training selection screen
              SliverList(
            delegate: SliverChildListDelegate(
              [
                // EntryTransition for header text
                EntryTransition(
                  position: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: GyminiTheme.verticalGapUnit * 2),
                    child: Text(
                      "¿Qué vamos a entrenar hoy?",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.primaryColorDark),
                    ),
                  ),
                ),

                // Display muscle carousel if muscles are available
                if (muscles.isNotEmpty)
                  EntryTransition(
                    position: 3,
                    child: MuscleCarouselSelector(muscles: muscles),
                  ),

                // Show the exercise header if exercises exist
                if (exercises.isNotEmpty)
                  EntryTransition(
                    position: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 30),
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
            ),
          ),
        )
      ],
    );
  }
}
