// A dedicated widget for the big training text.
import 'package:flutter/material.dart';

class BigTrainingText extends StatelessWidget {
  final int stage;
  const BigTrainingText({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¡Entrena\nAHORA!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'serie $stage',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }
}
