import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/muscle_carousel_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/muscle_tile.dart';

final muscles = [
  MuscleTileSchema(label: "Triceps", timeSinceExercise: 3, imagePath: "assets/images/muscles/triceps.svg"),
  MuscleTileSchema(label: "Biceps", timeSinceExercise: 3, imagePath: "assets/images/muscles/biceps.svg"),
  MuscleTileSchema(label: "Piernas", timeSinceExercise: 5, imagePath: "assets/images/muscles/piernas.svg"),
  MuscleTileSchema(label: "Dorsales", timeSinceExercise: 7, imagePath: "assets/images/muscles/dorsales.svg"),
  MuscleTileSchema(label: "pectorales", timeSinceExercise: 7, imagePath: "assets/images/muscles/pectorales.svg"),
  MuscleTileSchema(label: "hombros", timeSinceExercise: 11, imagePath: "assets/images/muscles/hombros.svg"),
];

final exercises = [
  ExerciseTileSchema(label: "Press Banca", timeSinceExercise: 7, imagePath: "assets/images/muscles/pectorales.svg"),
];

class WidgetTestingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        children: [

          const HeaderWidget(
            title: "Nuevo Entrenamiento",
            date: "09/06/2024",
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child:Text(
              "¿Qué vamos a entrenar hoy?",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark),
            )
          ),

          MuscleCarouselSelector(
            muscles:muscles
          ),

          ExerciseTile(exercise: exercises[0], isSelected: false,)

        ],
      ),
    );
  }
}