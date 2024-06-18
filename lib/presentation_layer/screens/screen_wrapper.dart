import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/screens/widget_testing_screen.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/back_button.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/next_button.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/stop_button.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/footer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/header_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/exercise_image_example.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/trainingSession/session_info_widget.dart';

class ScreenWrapper extends StatefulWidget {
  @override
  ScreenWrapperState createState() => ScreenWrapperState();
}

class ScreenWrapperState extends State<ScreenWrapper>{
  int currentScreen = 1;

  void onTabTapped(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(112.0),  // Adjust the height as necessary
        child: SafeArea( // Ensures content is below the status bar
          child: HeaderWidget(
            title: "Nuevo Entrenamiento",
            date: "09/06/2024",
          ),
        ),
      ),
      
      body: TestingScreen(),

      bottomNavigationBar: FooterNavigation(
        selectedIndex: currentScreen,
        onTabTapped: onTabTapped,
      ),
    );;
  }
}