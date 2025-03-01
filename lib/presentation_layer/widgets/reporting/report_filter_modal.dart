import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class ReportFilterModal extends ConsumerWidget {
  final VoidCallback onClose;

  const ReportFilterModal({required this.onClose, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerPost = ref.read(reportScreenProvider.notifier);
    final providerWatch = ref.watch(reportScreenProvider);
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
              DropdownButton<String>(
                hint: const Text('Select Muscle'),
                value: providerWatch.selectedMuscle?.id,
                items: providerWatch.allMuscles.map((muscle) {
                  return DropdownMenuItem<String>(
                    value: muscle.id,
                    child: Text(muscle.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    providerPost.selectMuscleById(newValue);
                    providerPost.filterSessions();
                  }
                },
              ),
              DropdownButton<String>(
                hint: const Text('Select Exercise'),
                value: providerWatch.selectedExercise?.id,
                items: providerWatch.filteredExercises.map((exercise) {
                  return DropdownMenuItem<String>(
                    value: exercise.id,
                    child: Text(exercise.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  providerPost.selectExerciseById(newValue!);
                  providerPost.filterSessions();
                },
              ),
            ],
          ),
        );
  }
}
