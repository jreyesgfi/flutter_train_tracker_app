import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/bottom_navigation.dart';
import 'package:go_router/go_router.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;

  const ScreenWrapper({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}