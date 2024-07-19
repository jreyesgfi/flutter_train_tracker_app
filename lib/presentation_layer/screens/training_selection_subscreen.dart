import 'package:flutter/material.dart';
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
    
    final muscles = ref.read(trainingScreenProvider.notifier).muscleTiles;
    final exercises = ref.read(trainingScreenProvider.notifier).exerciseTiles;

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
            child: Text(
              "¿Qué vamos a entrenar hoy?",
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
            ),
          ),
          // Display muscle carousel selector if muscles are available
          if (muscles.isNotEmpty)
            MuscleCarouselSelector(muscles:  muscles),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 30),
            child: Text(
              "Escoge un ejercicio",
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
            ),
          ),
          // Display exercise list selector if exercises are available
          if (exercises.isNotEmpty)
            ExerciseListSelector(exercises:exercises),
        ],
      ),
    );
  }
}
