// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gymini/common_layer/theme/app_theme.dart';
// import 'package:gymini/domain_layer/entities/session_info.dart';
// import 'package:gymini/presentation_layer/providers/scroll_controller_provider.dart';
// import 'package:gymini/features/create_training/provider/training_screen_provider.dart';
// import 'package:gymini/presentation_layer/services/training_data_transformer.dart';
// import 'package:gymini/presentation_layer/widgets/training_session/session_form.dart';
// import 'package:gymini/presentation_layer/widgets/common/other/custom_chrono.dart';
// import 'package:gymini/presentation_layer/widgets/training_session/exercise_image_example.dart';
// import 'package:gymini/presentation_layer/widgets/training_session/session_buttons_wrapper_test.dart';
// import 'package:gymini/presentation_layer/widgets/training_session/session_info_widget.dart';
// import 'package:gymini/presentation_layer/widgets/training_session/session_step_widget.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SessionSubscreen extends ConsumerStatefulWidget {
//   const SessionSubscreen({super.key});

//   @override
//   ConsumerState<SessionSubscreen> createState() => _SessionSubscreenState();
// }

// class _SessionSubscreenState extends ConsumerState<SessionSubscreen> {
//   int currentStage = 0;
//   final GlobalKey<SessionFormState> _formKey = GlobalKey<SessionFormState>();

//   @override
//   Widget build(BuildContext context) {
//     final ScrollController _scrollController = ref.watch(scrollControllerProvider);
//     final provider = ref.read(trainingScreenProvider.notifier);
//     final lastSession = provider.lastSessionSummary ??
//         SessionInfoSchema(
//             exerciseName: provider.selectedExercise?.name ?? '',
//             muscleGroup: provider.selectedMuscle?.name ?? '',
//             timeSinceLastSession: 0,
//             minWeight: 0,
//             maxWeight: 0,
//             minReps: 0,
//             maxReps: 0);
//     final selectedExercise = provider.selectedExercise;
//     final exerciseImagePaths = selectedExercise != null
//         ? TrainingDataTransformer.exerciseImagePaths(selectedExercise)
//         : [
//             "assets/images/exercises/shoulder/Dumbbell-lateral-raises-1.png",
//             "assets/images/exercises/shoulder/Dumbbell-lateral-raises-2.png"
//           ];

//     final theme = Theme.of(context);
//     bool isOddStage = currentStage % 2 != 0;
//     bool isLastEvenStage = currentStage == 8;

//     void onButtonClicked(int index) {
//       if (_formKey.currentState != null) {
//         if (_formKey.currentState?.getCurrentFormData() != null) {
//           SessionValues sessionValues =
//               _formKey.currentState!.getCurrentFormData();
//           provider.updateNewSession(sessionValues);
//         }
//       }

//       if (index == 9) {
//         provider.commitNewSession();
//         provider.resetStage();
//       }

//       setState(() {
//         currentStage = index;
//       });
//     }

//     return CustomScrollView(
//       controller: _scrollController,
//       slivers: [
//         SliverPadding(
//           padding: EdgeInsets.symmetric(
//               vertical: GyminiTheme.verticalGapUnit * 2,
//               horizontal: GyminiTheme.leftOuterPadding),
//           sliver: SliverToBoxAdapter(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width*0.65,
//                     child: Text(
//                     lastSession.exerciseName,
//                     style: theme.textTheme.titleSmall,
//                   ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     lastSession.muscleGroup,
//                     style: theme.textTheme.titleMedium,
//                   ),
//                   Text(
//                     '${lastSession.timeSinceLastSession} days ago',
//                     style: theme.textTheme.bodySmall
//                         ?.copyWith(color: theme.shadowColor),
//                   ),
//                 ]),
//                 SessionStepWidget(
//                     currentStep: (currentStage / 2).abs().round(),
//                     totalSteps: 4),
//               ],
//             ),
//           ),
//         ),

//         // Training or Resting Section
//         SliverPadding(
//           padding: EdgeInsets.symmetric(
//               vertical: GyminiTheme.verticalGapUnit * 2,
//               horizontal: GyminiTheme.leftOuterPadding),
//           sliver: SliverToBoxAdapter(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.5,
//               width: MediaQuery.of(context).size.width,
//               child: Center(
//                 child: Column(
//                   children: [
//                     if (currentStage == 0 || isOddStage) ...[
//                       ExerciseImageExample(
//                           exerciseImagePaths: exerciseImagePaths),
//                       SessionInfoWidget(sessionInfo: lastSession),
//                     ] else if (!isLastEvenStage) ...[
//                       CustomChrono(
//                         key: ValueKey(currentStage),
//                         duration: const Duration(minutes: 2),
//                       )
//                     ] else ...[
//                       SessionForm(
//                         key: _formKey,
//                         initialData: provider.newSessionSchema ?? lastSession,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),


//         // Buttons Section
//         SliverPadding(
//           padding: EdgeInsets.symmetric(
//               vertical: GyminiTheme.verticalGapUnit * 2,
//               horizontal: GyminiTheme.leftOuterPadding),
//           sliver: SliverToBoxAdapter(
//             child: SessionButtonsWrapper(
//               currentStage: currentStage,
//               onButtonClicked: onButtonClicked,
//               cancelTraining: provider.resetStage,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
