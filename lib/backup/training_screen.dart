// import 'package:flutter/material.dart';
// import 'package:gymini/features/select_training/ui/training_selection_view.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Main TrainingScreen widget that wraps content in ProviderScope
// class TrainingScreen extends StatelessWidget {
//   const TrainingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _TrainingScreenContent();
//   }
// }

// // The actual content of the TrainingScreen, where we consume the provider
// class _TrainingScreenContent extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     const bool selectionDone = false; //ref.watch(trainingScreenProvider).currentStage != 0;
//     // Depending on the state of `allMuscles`, show either the content or a loading indicator
//     if (selectionDone == false) {
//       // IndexedStack is used to switch between different subscreens based on `currentStage`
//       return 
//         const TrainingSelectionView(key: ValueKey(selectionDone));
//     } else {
//       // Show a loading spinner while the data is being fetched
//       return 
//       const TrainingSelectionView(key: ValueKey(selectionDone));
//         //SessionSubscreen(key: ValueKey(selectionDone));
//     }
//   }
// }
