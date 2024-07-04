import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _loadInitialData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var allMuscles = snapshot.data![0] as List<MuscleData>;
          var allExercises = snapshot.data![1] as List<ExerciseData>;

          return ChangeNotifierProvider<ReportScreenProvider>(
            create: (_) => ReportScreenProvider(allMuscles, allExercises),
            child: _buildReportScreen(context),
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
    return [allMuscles, allExercises];
  }

  Widget _buildReportScreen(BuildContext context) {
    return Consumer<ReportScreenProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            DropdownButton<String>(
              hint: Text('Select Muscle'),
              value: provider.selectedMuscle?.id,
              items: provider.allMuscles.map((MuscleData muscle) {
                return DropdownMenuItem<String>(
                  value: muscle.id,
                  child: Text(muscle.name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                provider.selectMuscleById(newValue);
                provider.filterSessions(); // Trigger filtering
              },
            ),
            DropdownButton<String>(
              hint: Text('Select Exercise'),
              value: provider.selectedExercise?.id,
              items: provider.allExercises.map((ExerciseData exercise) {
                return DropdownMenuItem<String>(
                  value: exercise.id,
                  child: Text(exercise.name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                provider.selectExerciseById(newValue!);
                provider.filterSessions(); // Trigger filtering
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: provider.filteredSessions.isEmpty
                    ? Center(child: Text('No data available'))
                    : MaxMinLineChart(sessions: provider.filteredSessions),
              ),
            )
          ],
        );
      },
    );
  }
}
