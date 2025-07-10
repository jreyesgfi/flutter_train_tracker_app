import 'package:flutter/material.dart';
import 'package:gymini/common/shared_data/shared_preferences/chrono_storage.dart';
import 'package:gymini/features/process_training/ui/widgets/custom_chrono.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_big_text_screen.dart';
import 'package:gymini/presentation_layer/widgets/training_session/exercise_image_example.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_form.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_info_widget.dart';

class TrainingStageSwitcher extends StatelessWidget {
  final int currentStage;
  final dynamic sessionTile; // Replace with your actual SessionTile type.
  final List<String> exerciseImagePaths;
  final void Function(dynamic)? onSessionDataChanged; // New callback
  final int lastStage;

  const TrainingStageSwitcher({
    super.key,
    required this.currentStage,
    required this.sessionTile,
    required this.exerciseImagePaths,
    required this.lastStage,
    this.onSessionDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    // For the first stage, show the info.
    if (currentStage == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExerciseImageExample(
            exerciseImagePaths: exerciseImagePaths,
          ),
          SessionInfoWidget(
            sessionInfo: sessionTile,
          ),
        ],
      );
    }

    // Using the same logic as before.
    bool isOddStage = currentStage % 2 != 0;
    bool isLastEvenStage = currentStage == lastStage;

    // For the last stage, show only the SessionForm.
    if (isLastEvenStage) {
      return SessionForm(
        initialData: sessionTile,
        onChanged: onSessionDataChanged, // Pass callback here
      );
    }

    // Otherwise, use a horizontal PageView with two pages.
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        physics: const PageScrollPhysics(),
        controller: PageController(viewportFraction: 1.0),
        children: (currentStage == 0 || isOddStage)
            ? [
                // Page 1: Big text.
                BigTrainingText(stage: (1 + currentStage) ~/ 2),
                // Page 2: Combination of image and session info.
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExerciseImageExample(
                      exerciseImagePaths: exerciseImagePaths,
                    ),
                    SessionInfoWidget(
                      sessionInfo: sessionTile,
                    ),
                  ],
                ),
              ]
            : [
                // For even stages (not last)
                // Page 1 is the chrono.
                FutureBuilder<DateTime>(
                  future: ChronoStorage.loadStartTime(currentStage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error loading timer"));
                    }
                    final startTime = snapshot.data!;
                    return Column(
                      children: [
                        Expanded(
                          child: SimpleChrono(
                            duration: const Duration(minutes: 2),
                            startTime: startTime,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Page 2 is the SessionForm.
                SessionForm(
                  initialData: sessionTile,
                  onChanged: onSessionDataChanged, // Pass callback here too
                ),
              ],
      ),
    );
  }
}
