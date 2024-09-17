import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/route_provider.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';
import 'package:flutter_application_test1/presentation_layer/screens/session_subscreen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/settings_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_subscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main TrainingScreen widget that wraps content in ProviderScope
class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TrainingScreenContent();
  }
}

// The actual content of the TrainingScreen, where we consume the provider
class _TrainingScreenContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool selectionDone = ref.watch(trainingScreenProvider).currentStage != 0;
    // Depending on the state of `allMuscles`, show either the content or a loading indicator
    if (selectionDone == false) {
      // IndexedStack is used to switch between different subscreens based on `currentStage`
      return 
        TrainingSelectionSubscreen(key: ValueKey(selectionDone));
    } else {
      // Show a loading spinner while the data is being fetched
      return 
        SessionSubscreen(key: ValueKey(selectionDone));
    }
  }
}
