// lib/features/process_training/ui/process_training_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/features/process_training/provider/process_training_provider.dart';
import 'package:gymini/features/process_training/provider/process_training_notifier.dart';

class ProcessTrainingView extends ConsumerWidget {
  const ProcessTrainingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(processTrainingProvider);
    final notifier = ref.read(processTrainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Process Training"),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Display session details or form fields to edit session values.
                if (state.session != null)
                  Text("Session ID: ${state.session!.id}"),
                // Add other UI elements to input maxWeight, etc.
                ElevatedButton(
                  onPressed: () async {
                    // Suppose we have collected new session values from the UI.
                    final sessionValues = SessionValues(
                      maxWeight: 100,
                      minWeight: 50,
                      maxReps: 10,
                      minReps: 5,
                    );
                    notifier.updateSessionValues(sessionValues);
                    await notifier.commitSession();
                  },
                  child: const Text("Save Session"),
                ),
                if (state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
    );
  }
}
