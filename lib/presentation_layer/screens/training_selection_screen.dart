import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/services/training_data_transformer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_list_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/footer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/header_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_carousel_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_selection/muscle_tile.dart';


class TrainingSelectionSubscreen extends StatefulWidget{
  final List<MuscleData> muscles;
  final List<ExerciseData> exercises;

  TrainingSelectionSubscreen({
    super.key,
    required this.muscles,
    required this.exercises,
  });

  
  @override
  TrainingSelectionState createState() => TrainingSelectionState();
}


class TrainingSelectionState extends State<TrainingSelectionSubscreen> {
  
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

          Container(
            margin: const EdgeInsets.only(left:20.0, right:10.0, bottom: 0.0, top:30),
            child:Text(
              "¿Qué vamos a entrenar hoy?",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark),
            )
          ),

          MuscleCarouselSelector(
            muscles:TrainingDataTransformer.transformMusclesToTiles(widget.muscles)
          ),

          Container(
            margin: const EdgeInsets.only(left:20.0, right:10.0, bottom: 0.0, top:30),
            child:Text(
              "Escoge un ejercicio",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark),
            )
          ),


          ExerciseListSelector(
            exercises: TrainingDataTransformer.transformExercisesToTiles(widget.exercises),
          ),

        ],
      ),
    );
  }
}