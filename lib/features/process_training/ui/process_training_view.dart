import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common/shared_data/shared_preferences/chrono_storage.dart';
import 'package:gymini/features/process_training/provider/process_training_provider.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_buttons_wrapper.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_header_widget.dart';
import 'package:gymini/features/process_training/ui/widgets/process_training_states_switcher.dart';
import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:gymini/presentation_layer/widgets/training_session/session_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessTrainingView extends ConsumerStatefulWidget {
  const ProcessTrainingView({super.key});

  @override
  ConsumerState<ProcessTrainingView> createState() =>
      _ProcessTrainingViewState();
}

class _ProcessTrainingViewState extends ConsumerState<ProcessTrainingView> {
  int currentStage = 0;
  int lastStage = 8;
  final GlobalKey<SessionFormState> _formKey = GlobalKey<SessionFormState>();

  @override
  void initState() {
    super.initState();
    _loadCurrentStage();
  }

  Future<void> _loadCurrentStage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentStage = prefs.getInt('current_stage') ?? 0;
    });
  }

  Future<void> _updateCurrentStage(int newStage) async {
    setState(() {
      currentStage = newStage;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_stage', newStage);
  }

  void onButtonClicked(int index) {
    if (_formKey.currentState?.getCurrentFormData() != null) {
      final sessionValues = _formKey.currentState!.getCurrentFormData();
      ref.read(processTrainingProvider.notifier).updateSessionValues(sessionValues);
    }
    if (index > lastStage) {
      ref.read(processTrainingProvider.notifier).commitSession();
      ChronoStorage.deleteAllChronoStartTimes();
      index = 0;
    }
    _updateCurrentStage(index);
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ref.watch(scrollControllerProvider);
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

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Header section: display session summary and step indicator.
        ProcessTrainingHeaderWidget(
          sessionTile: sessionTile,
          currentStage: currentStage,
        ),
        // Main content section.
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: GyminiTheme.verticalGapUnit * 2,
            horizontal: GyminiTheme.leftOuterPadding,
          ),
          sliver: SliverToBoxAdapter(
            child: TrainingStageSwitcher(
              currentStage: currentStage,
              lastStage: lastStage,
              sessionTile: sessionTile,
              exerciseImagePaths: exerciseImagePaths,
              onSessionDataChanged: (updatedValues) {
                notifier.updateSessionValues(updatedValues);
              },
            ),
          ),
        ),
        // Buttons Section.
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
        ),
      ],
    );
  }
}
