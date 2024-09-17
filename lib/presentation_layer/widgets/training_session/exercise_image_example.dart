import 'package:flutter/material.dart';

class ExerciseImageExample extends StatelessWidget {
  final exerciseImagePaths;

  const ExerciseImageExample({
    super.key,
    required this.exerciseImagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height:300,
        child: Row(children: [
          Expanded(
            child: Image.asset(
              exerciseImagePaths?[0],
              fit: BoxFit.fitWidth,
            ),
          ),
        ]));
  }
}
