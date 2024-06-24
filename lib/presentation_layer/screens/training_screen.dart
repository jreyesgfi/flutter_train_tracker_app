import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_subscreen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/screens/new_session_subscreen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_test1/models/session_info.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This returns a scaffold directly wrapped in a ChangeNotifierProvider.
    return ChangeNotifierProvider<TrainingSubScreenProvider>(
      create: (_) => TrainingSubScreenProvider(),
      child: Scaffold(
        body: Consumer<TrainingSubScreenProvider>(
          builder: (context, provider, child) {
            Widget content;
            switch (provider.currentStage) {
              case 0:
                content = TrainingSelectionSubscreen();
                break;
              case 1:
                content = SessionSubscreen();
                break;
              default:
                content = TrainingSelectionSubscreen();
            }
            return content;
          },
        ),
      ),
    );
  }
}
