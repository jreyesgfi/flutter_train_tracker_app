import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/exercise_list_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/exercise_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/footer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/header_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/muscle_carousel_selector.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/muscle_tile.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/session_info_widget.dart';

final lastTrainingData = PreviousSessionInfoSchema(
  exerciseName: "Elevaciones Frontales",
  muscleGroup: "Hombro",
  timeSinceLastSession: 6,
  minWeight: 12,
  maxWeight: 12,
  minReps: 12,
  maxReps: 14);

class TestingScreen extends StatefulWidget{
  @override
  TestingScreenState createState() => TestingScreenState();
}


class TestingScreenState extends State<TestingScreen> {
  
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

          SessionInfoWidget(
            sessionInfo: lastTrainingData
          )

          

        ],
      ),

      bottomNavigationBar: FooterNavigation(
        selectedIndex: selectedIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}