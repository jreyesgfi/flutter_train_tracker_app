import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/screens/session_subscreen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_subscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingScreenProvider);
    
    // Load completed and data is available
    if (state.allMuscles.isNotEmpty) {
      return IndexedStack(
        index: state.currentStage,
        children: [
          TrainingSelectionSubscreen(),
          SessionSubscreen(),
        ],
      );
    } else {
      // Loading state
      return Center(child: CircularProgressIndicator());
    }
  }
}
