import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/screens/screen_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/screens/settings_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/report_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/training',
  routes: [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) => ScreenWrapper(child: child),
      routes: [
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: SettingsScreen()),
        ),
        GoRoute(
          path: '/training',
          name: 'training',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: TrainingScreen()),
        ),
        GoRoute(
          path: '/report',
          name: 'report',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: ReportScreen()),
        ),
      ],
    ),
  ],
);
