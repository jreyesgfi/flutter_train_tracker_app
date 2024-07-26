import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_form.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/custom_chrono.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/exercise_image_example.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_buttons_wrapper.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_info_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_step_widget.dart';

final lastTrainingData = SessionInfoSchema(
    exerciseName: "Elevaciones Frontales",
    muscleGroup: "Hombro",
    timeSinceLastSession: 6,
    minWeight: 16,
    maxWeight: 19,
    minReps: 12,
    maxReps: 12);

class TestingScreen extends StatefulWidget {
  @override
  TestingScreenState createState() => TestingScreenState();
}

class TestingScreenState extends State<TestingScreen> {
  // Footer manage the screen
  int currentStage = 0;

  void onButtonClicked(int index) {
    setState(() {
      currentStage = index;
    });
  }

  //dev
  final exerciseImagePaths = [
    "assets/images/exercises/shoulder/Dumbbell-lateral-raises-1.png",
    "assets/images/exercises/shoulder/Dumbbell-lateral-raises-2.png"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isOddStage = currentStage % 2 != 0;
    bool isLastEvenStage = currentStage == 8;

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
                  lastTrainingData.exerciseName,
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 4),
                Text(
                  lastTrainingData.muscleGroup,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '${lastTrainingData.timeSinceLastSession} days ago',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.shadowColor),
                ),
              ]),
              if (currentStage == 0 || isOddStage) ...[
                ExerciseImageExample(exerciseImagePaths: exerciseImagePaths),
                SessionInfoWidget(sessionInfo: lastTrainingData),
              ]
              else ...[
                if (!isLastEvenStage)
                  CustomChrono(
                    key: ValueKey(currentStage),
                    duration: const Duration(minutes: 2)),
                  SessionForm(
                      initialData: lastTrainingData,
                      onResultsChanged: (results) {}),
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
