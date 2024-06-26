import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/screens/session_subscreen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_subscreen.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _loadInitialData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          var allMuscles = snapshot.data![0] as List<MuscleData>;
          var allExercises = snapshot.data![1] as List<ExerciseData>;
          var lastSessions = snapshot.data![2] as List<SessionData>;

          return ChangeNotifierProvider<TrainingScreenProvider>(
            create: (_) => TrainingScreenProvider(allMuscles, allExercises, lastSessions),
            child: _buildTrainingScreen(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<dynamic>> _loadInitialData() async {
    var repo = MockDataRepository();
    List<MuscleData> allMuscles = await repo.fetchAllMuscles();
    List<ExerciseData> allExercises = await repo.fetchAllExercises();
    List<SessionData> lastSessions = await repo.fetchLastSessions();
    return [allMuscles, allExercises, lastSessions];
  }

  Widget _buildTrainingScreen() {
    return Consumer<TrainingScreenProvider>(
      builder: (context, provider, child) {
        switch (provider.currentStage) {
          case 0:
            return TrainingSelectionSubscreen();
          case 1:
            return SessionSubscreen();
          default:
            return TrainingSelectionSubscreen();
        }
      },
    );
  }
}
