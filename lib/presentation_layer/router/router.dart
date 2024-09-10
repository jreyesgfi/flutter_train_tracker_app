import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/screens/history_screen.dart';
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
              NoAnimationPage(key: state.pageKey, child: SettingsScreen()),
        ),
        GoRoute(
          path: '/training',
          name: 'training',
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: TrainingScreen()),
        ),
        GoRoute(
          path: '/report',
          name: 'report',
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: ReportScreen()),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: HistoryScreen()),
        ),
      ],
    ),
  ],
);


class NoAnimationPage<T> extends Page<T> {
  final Widget child;

  NoAnimationPage({required this.child, LocalKey? key}) : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (_, __, ___) => child,
      transitionDuration: Duration.zero,
    );
  }
}