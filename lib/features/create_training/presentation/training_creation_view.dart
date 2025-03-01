// lib/features/create_training/presentation/training_selection_subscreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/features/create_training/provider/create_training_provider.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/exercise_list_selector.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_carousel_selector.dart';

class TrainingCreationView extends ConsumerWidget {
  const TrainingCreationView({Key? super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scrollController = ref.watch(scrollControllerProvider);

    // Watch the createTrainingProvider
    final state = ref.watch(createTrainingProvider);
    // Read notifier to call its methods
    final notifier = ref.read(createTrainingProvider.notifier);

    final muscles = state.muscleTiles;
    final exercises = state.exerciseTiles;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                EntryTransition(
                  position: 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: GyminiTheme.verticalGapUnit * 2),
                    child: Text(
                      "¿Qué vamos a entrenar hoy?",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.primaryColorDark),
                    ),
                  ),
                ),
                if (muscles.isNotEmpty)
                  EntryTransition(
                    position: 3,
                    child: MuscleCarouselSelector(
                      muscles: muscles,
                      onMuscleSelected: (muscleId) {
                        final muscle = state.allMuscles.firstWhere((m) => m.id == muscleId);
                        notifier.selectMuscle(muscle);
                      },
                      onToggleLike: (muscleId) {
                        notifier.toggleMuscleLikeState(muscleId);
                      },
                    ),
                  ),
                if (exercises.isNotEmpty)
                  EntryTransition(
                    position: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
                      child: Text(
                        "Escoge un ejercicio",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.primaryColorDark),
                      ),
                    ),
                  ),
                if (exercises.isNotEmpty)
                  EntryTransition(
                    position: 5,
                    child: ExerciseListSelector(
                      exercises: exercises,
                      onExerciseSelected: (exerciseId) {
                        final exercise = state.allExercises.firstWhere((e) => e.id == exerciseId);
                        notifier.selectExercise(exercise);
                      },
                      onToggleLike: (exerciseId) {
                        notifier.toggleExerciseLikeState(exerciseId);
                      },
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

