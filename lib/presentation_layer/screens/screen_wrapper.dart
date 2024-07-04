import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/screens/report_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_screen.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/footer.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/header_widget.dart';

class ScreenWrapper extends StatefulWidget {
  @override
  ScreenWrapperState createState() => ScreenWrapperState();
}

class ScreenWrapperState extends State<ScreenWrapper> {
  int currentScreen = 0;

  void onTabTapped(int index) {
    setState(() {
      currentScreen = index;
    });
  }

  Widget _getScreen() {
    switch (currentScreen) {
      case 0:
        return TrainingScreen();
      case 1:
        return TrainingScreen();
      case 2:
        return ReportScreen();
      default:
        return TrainingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(112.0), // Adjust the height as necessary
        child: SafeArea( // Ensures content is below the status bar
          child: HeaderWidget(
            title: "Nuevo Entrenamiento",
            date: "09/06/2024",
          ),
        ),
      ),
      body: _getScreen(),
      bottomNavigationBar: FooterNavigation(
        selectedIndex: currentScreen,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
