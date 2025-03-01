import 'package:flutter/material.dart';

class ExerciseImageExample extends StatelessWidget {
  final List<String?> exerciseImagePaths;

  const ExerciseImageExample({
    super.key,
    required this.exerciseImagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height:300,
        child: Row(children: [
          Expanded(
            child: Image.asset(
              exerciseImagePaths[0]!,
              fit: BoxFit.fitWidth,
            ),
          ),
        ]));
  }
}
