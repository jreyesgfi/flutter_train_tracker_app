import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/exercise_list_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/footer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/header_widget.dart';
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
  ExerciseTileSchema(label: "Press Banca", timeSinceExercise: 7, imagePath: "assets/images/exercises/pectoral/Bench-press-1.png"),
  ExerciseTileSchema(label: "Máquina pecho", timeSinceExercise: 7, imagePath: "assets/images/exercises/pectoral/Incline-chest-press-1.png"),
];

class TrainingSelectionScreen extends StatefulWidget{
  @override
  TrainingSelectionState createState() => TrainingSelectionState();
}


class TrainingSelectionState extends State<TrainingSelectionScreen> {
  
  // Footer manage the screen
  int selectedIndex = 0;
  
  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  
  
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
            margin: const EdgeInsets.only(left:10.0, right:10.0, bottom: 0.0, top:30),
            child:Text(
              "¿Qué vamos a entrenar hoy?",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark),
            )
          ),

          MuscleCarouselSelector(
            muscles:muscles
          ),

          Container(
            margin: const EdgeInsets.only(left:10.0, right:10.0, bottom: 0.0, top:30),
            child:Text(
              "Escoge un ejercicio",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark),
            )
          ),


          ExerciseListSelector(
            exercises: exercises
          ),

        ],
      ),

      bottomNavigationBar: FooterNavigation(
        selectedIndex: selectedIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}