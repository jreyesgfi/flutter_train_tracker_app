import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';
import 'package:flutter_application_test1/presentation_layer/screens/screen_wrapper.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => ScreenWrapper(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text(state.error.toString())),
  ),
);