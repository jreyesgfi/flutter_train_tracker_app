import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/screens/profile_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/report_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';
import 'package:flutter_application_test1/presentation_layer/screens/screen_wrapper.dart';


final GoRouter router = GoRouter(
  initialLocation: '/train',
  routes: [
    GoRoute(
      path: '/profile',
      name: AppRoute.profile.name,
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/train',
      name: AppRoute.train.name,
      builder: (context, state) => const TrainingScreen(),
    ),
    GoRoute(
      path: '/statistics',
      name: AppRoute.report.name,
      builder: (context, state) => const ReportScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text(state.error.toString())),
  ),
);
