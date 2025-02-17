import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/providers/route_provider.dart';
import 'package:gymini/presentation_layer/router/routes.dart';
import 'package:gymini/presentation_layer/screens/history_screen.dart';
import 'package:gymini/presentation_layer/screens/screen_wrapper.dart';
import 'package:gymini/presentation_layer/screens/session_subscreen.dart';
import 'package:gymini/presentation_layer/screens/training_selection_subscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymini/presentation_layer/screens/settings_screen.dart';
import 'package:gymini/presentation_layer/screens/training_screen.dart';
import 'package:gymini/presentation_layer/screens/report_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/trainingSelection',
  routes: [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: customShellRouteBuilder,
      routes: [
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: SettingsScreen()),
        ),
        GoRoute(
          path: '/trainingSelection',
          name: AppSubRoute.trainingSelection.name,
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: TrainingScreen())
        ),
        GoRoute(
          path: '/trainingSession',
          name: AppSubRoute.trainingSession.name,
          pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: TrainingScreen())
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

Widget customShellRouteBuilder(
    BuildContext context, GoRouterState state, Widget child) {
  return ProviderScope(
    child: ScreenWrapper(child: child),
  );
}

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

