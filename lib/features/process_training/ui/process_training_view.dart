// lib/features/process_training/ui/process_training_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/features/process_training/provider/process_training_provider.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_buttons_wrapper.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_header_widget.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_form.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_info_widget.dart';
import 'package:gymini/presentation_layer/widgets/common/other/custom_chrono.dart';
import 'package:gymini/presentation_layer/widgets/training_session/exercise_image_example.dart';

class ProcessTrainingView extends ConsumerStatefulWidget {
  const ProcessTrainingView({super.key});

  @override
  ConsumerState<ProcessTrainingView> createState() =>
      _ProcessTrainingViewState();
}

class _ProcessTrainingViewState extends ConsumerState<ProcessTrainingView> {
  int currentStage = 0;
  final GlobalKey<SessionFormState> _formKey = GlobalKey<SessionFormState>();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController =
        ref.watch(scrollControllerProvider);
    final state = ref.watch(processTrainingProvider);
    final notifier = ref.read(processTrainingProvider.notifier);

    // Use the sessionTile already stored in state for summary and images.
    final sessionTile = state.sessionTile;
      
    // Use the image paths stored in the sessionTile.
    final List<String> exerciseImagePaths = sessionTile.pathImages.isNotEmpty
        ? sessionTile.pathImages
        : [
            "assets/images/exercises/default1.png",
            "assets/images/exercises/default2.png"
          ];

    bool isOddStage = currentStage % 2 != 0;
    bool isLastEvenStage = currentStage == 8; // Adjust based on your logic.

    void onButtonClicked(int index) {
      if (_formKey.currentState?.getCurrentFormData() != null) {
        final sessionValues = _formKey.currentState!.getCurrentFormData();
        notifier.updateSessionValues(sessionValues);
      }
      if (index == 9) {
        notifier.commitSession();
        notifier.previousStage(); // Or call a dedicated reset method.
      }
      setState(() {
        currentStage = index;
      });
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Header section: display session summary and step indicator.
        ProcessTrainingHeaderWidget(sessionTile: sessionTile, currentStage: currentStage),

        // Main content section.
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: GyminiTheme.verticalGapUnit * 2,
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    if (currentStage == 0 || isOddStage) ...[
                      ExerciseImageExample(
                        exerciseImagePaths: exerciseImagePaths,
                      ),
                      SessionInfoWidget(
                        sessionInfo: sessionTile,
                      ),
                    ] else if (!isLastEvenStage) ...[
                      CustomChrono(
                        key: ValueKey(currentStage),
                        duration: const Duration(minutes: 2),
                      ),
                    ] else ...[
                      SessionForm(
                        key: _formKey,
                        initialData: sessionTile,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        // Buttons Section
        SliverPadding(
          padding: EdgeInsets.symmetric(
              vertical: GyminiTheme.verticalGapUnit * 2,
              horizontal: GyminiTheme.leftOuterPadding),
          sliver: SliverToBoxAdapter(
            child: SessionButtonsWrapper(
              currentStage: currentStage,
              onButtonClicked: onButtonClicked,
              cancelTraining: notifier.resetStage,
            ),
          ),
        )
      ],
    );
  }
}
