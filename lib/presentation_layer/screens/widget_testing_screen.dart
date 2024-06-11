import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/muscle_tile.dart';

class WidgetTestingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [

          HeaderWidget(
            title: "Nuevo Entrenamiento",
            date: "09/06/2024",
          ),

          MuscleTile(
            label: "Triceps", 
            timeSinceExercise: 10,
            imagePath: "assets/images/muscles/triceps.svg")
          
        ],
      ),
    );
  }
}