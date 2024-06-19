import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/exercise_image_example.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/session_buttons_wrapper.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/session_info_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/session_step_widget.dart';

final lastTrainingData = PreviousSessionInfoSchema(
    exerciseName: "Elevaciones Frontales",
    muscleGroup: "Hombro",
    timeSinceLastSession: 6,
    minWeight: 12,
    maxWeight: 12,
    minReps: 12,
    maxReps: 14);

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Stack(
      children: [
        Positioned(
              top: 0,
              right: 0,
              child: SessionStepWidget(currentStep: (currentStage/2).abs().round(), totalSteps: 4)),
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
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.shadowColor),
            ),
          ]),
          ExerciseImageExample(exerciseImagePaths: exerciseImagePaths),
          SessionInfoWidget(sessionInfo: lastTrainingData),
          const SizedBox(height: 50),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     StopIconButton(onTap: () => {}),
          //     const SizedBox(width: 10), // Adjust width for desired spacing
          //     BackIconButton(onTap: () => {}),
          //     const SizedBox(width: 10), // Adjust width for desired spacing
          //     NextIconButton(onTap: () => {}),
          //   ],
          // ),
          const SizedBox(height: 10),
          SessionButtonsWrapper(
            currentStage: currentStage,
            onButtonClicked: onButtonClicked,
          ),
        ],
      ),
    ]
    ));
  }
}
