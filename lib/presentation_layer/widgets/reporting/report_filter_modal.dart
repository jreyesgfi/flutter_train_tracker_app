import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:provider/provider.dart';

class ReportFilterModal extends StatelessWidget {
  final VoidCallback onClose;

  const ReportFilterModal({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportScreenProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
              DropdownButton<String>(
                hint: Text('Select Muscle'),
                value: provider.selectedMuscle?.id,
                items: provider.allMuscles.map((muscle) {
                  return DropdownMenuItem<String>(
                    value: muscle.id,
                    child: Text(muscle.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  provider.selectMuscleById(newValue);
                  provider.filterSessions(); // Trigger filtering
                },
              ),
              DropdownButton<String>(
                hint: Text('Select Exercise'),
                value: provider.selectedExercise?.id,
                items: provider.allExercises.map((exercise) {
                  return DropdownMenuItem<String>(
                    value: exercise.id,
                    child: Text(exercise.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  provider.selectExerciseById(newValue!);
                  provider.filterSessions(); // Trigger filtering
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
