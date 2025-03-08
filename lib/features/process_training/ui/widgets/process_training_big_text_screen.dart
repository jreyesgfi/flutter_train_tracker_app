// A dedicated widget for the big training text.
import 'package:flutter/material.dart';

class BigTrainingText extends StatelessWidget {
  final int stage;
  const BigTrainingText({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Serie $stage, \n\n¡a entrenar!",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
      ),
    );
  }
}
