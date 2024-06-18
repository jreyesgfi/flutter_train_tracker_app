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
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(children: [
          Expanded(
            child: Image.asset(
              exerciseImagePaths?[0],
              width: 48, // Specify a width for the SVG image
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Image.asset(
              exerciseImagePaths?[1],
              width: 48, // Specify a width for the SVG image
              fit: BoxFit.fitHeight,
            ),
          )
        ]));
  }
}
