import 'package:flutter/material.dart';
 import 'package:flutter_svg/flutter_svg.dart';

class MuscleTile extends StatelessWidget {
  final String label;
  final int timeSinceExercise; //days
  final String imagePath;
  final bool isSelected;

  const MuscleTile({
    super.key,
    required this.label,
    required this.timeSinceExercise,
    required this.imagePath,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      child:Container(
        width: 120,
        height: 100,

        decoration: BoxDecoration(
          color: isSelected ? theme.shadowColor : theme.primaryColorLight,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              right:10,
              child:Align(
                alignment: Alignment.centerRight,
                child:SvgPicture.asset(imagePath,
                  height: 80,
                  fit:BoxFit.fitHeight,
                ),
              )
            ),
            Padding( // Use Padding instead of Positioned for the text
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Use a white background for the text container
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  '${timeSinceExercise.toString()} días',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor),
                ),
              ),
            )
          ],
        )));
  }
}
