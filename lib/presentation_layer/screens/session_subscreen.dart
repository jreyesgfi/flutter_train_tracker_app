import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_form.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/other/custom_chrono.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/exercise_image_example.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_buttons_wrapper.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_info_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_step_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionSubscreen extends ConsumerStatefulWidget {
  const SessionSubscreen({super.key});

  @override
  ConsumerState<SessionSubscreen> createState() => SessionSubscreenState();
}

class SessionSubscreenState extends ConsumerState<SessionSubscreen> {
  // Footer manage the screen
  int currentStage = 0;
  final GlobalKey<SessionFormState> _formKey = GlobalKey<SessionFormState>();

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(trainingScreenProvider.notifier);
    final lastSession = provider.lastSessionSummary ??
        SessionInfoSchema(
            exerciseName: provider.selectedExercise!.name,
            muscleGroup: provider.selectedMuscle!.name,
            timeSinceLastSession: 0,
            minWeight: 5,
            maxWeight: 5,
            minReps: 10,
            maxReps: 10);
    final selectedExercise = provider.selectedExercise;
    final exerciseImagePaths = selectedExercise != null
        ? TrainingDataTransformer.exerciseImagePaths(selectedExercise)
        : // default images
        [
            "assets/images/exercises/shoulder/Dumbbell-lateral-raises-1.png",
            "assets/images/exercises/shoulder/Dumbbell-lateral-raises-2.png"
          ];

    final theme = Theme.of(context);
    bool isOddStage = currentStage % 2 != 0;
    bool isLastEvenStage = currentStage == 8;

    void onButtonClicked(int index) {
      // Retrieve data from form and update provider
      if (_formKey.currentState != null) {
        SessionValues sessionValues =
            _formKey.currentState!.getCurrentFormData();
        provider.updateNewSession(sessionValues);
      }

      // Last stage
      if (index == 9) {
        provider.commitNewSession();
        provider.resetStage();
      }

      // Change the session stage
      setState(() {
        currentStage = index;
      });
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Stack(children: [
          Positioned(
              top: 0,
              right: 0,
              child: SessionStepWidget(
                  currentStep: (currentStage / 2).abs().round(),
                  totalSteps: 4)),
          ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  lastSession.exerciseName,
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 4),
                Text(
                  lastSession.muscleGroup,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '${lastSession.timeSinceLastSession} days ago',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.shadowColor),
                ),
              ]),
              // TRAINING
              if (currentStage == 0 || isOddStage) ...[
                ExerciseImageExample(exerciseImagePaths: exerciseImagePaths),
                SessionInfoWidget(sessionInfo: lastSession),
              ]
              // RESTING
              else ...[
                if (!isLastEvenStage)
                  CustomChrono(
                      key: ValueKey(currentStage),
                      duration: const Duration(minutes: 2)),
                SessionForm(
                    key: _formKey,
                    initialData: provider.newSessionSchema ?? lastSession),
              ],
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SessionButtonsWrapper(
              currentStage: currentStage,
              onButtonClicked: onButtonClicked,
            ),
          ),
        ]));
  }
}
