import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/screens/session_subscreen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_screen.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<MuscleData> allMuscles = [];
  List<ExerciseData> allExercises = [];

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() async {
    // Ideally, these would come from a service that fetches data from a repository
    allMuscles = await MockDataRepository().fetchAllMuscles();
    allExercises = await MockDataRepository().fetchAllExercises();
    setState(() {});
  }

  void handleMuscleSelection(MuscleData muscle) {
    Provider.of<TrainingScreenProvider>(context, listen: false).selectMuscle(muscle);
  }

  void handleExerciseSelection(ExerciseData exercise) {
    Provider.of<TrainingScreenProvider>(context, listen: false).selectExercise(exercise);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingScreenProvider>(
      create: (_) => TrainingScreenProvider(),
      child: Scaffold(
        body: Consumer<TrainingScreenProvider>(
          builder: (context, provider, child) {
            Widget content;
            switch (provider.currentStage) {
              case 0:
                content = TrainingSelectionSubscreen(
                  muscles: allMuscles,
                  exercises: allExercises,
                );
                break;
              case 1:
                content = SessionSubscreen();
                break;
              default:
                content = TrainingSelectionSubscreen(
                  muscles: allMuscles,
                  exercises: allExercises,
                );
            }
            return content;
          },
        ),
      ),
    );
  }
}
