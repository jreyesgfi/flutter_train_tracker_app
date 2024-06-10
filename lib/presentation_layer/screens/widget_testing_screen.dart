import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_widget.dart';

class WidgetTestingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          // Add HeaderWidget for testing
          HeaderWidget(
            title: "Nuevo Entrenamiento",
            date: "09/06/2024",
          ),
          // Add other test widgets here as you develop them
        ],
      ),
    );
  }
}