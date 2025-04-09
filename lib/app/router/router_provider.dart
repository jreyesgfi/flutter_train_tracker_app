// lib/app/router/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymini/app/router/router_notifier.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/features/history/ui/history_view.dart';
import 'package:gymini/features/process_training/ui/process_training_view.dart';
import 'package:gymini/features/report/ui/report_view.dart';
import 'package:gymini/features/select_training/ui/select_training_view.dart';
import 'package:gymini/common/widgets/screen_wrapper.dart';
import 'package:gymini/presentation_layer/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final globalStreams = ref.watch(globalSharedStreamsProvider);
  final refreshStream = GoRouterRefreshStream(globalStreams.selectedExerciseStream.stream);

  return GoRouter(
    initialLocation: '/trainingSelection',
    refreshListenable: refreshStream,
    // Redirect based on the selected exercise value.
    redirect: (BuildContext context, GoRouterState state) {
      final selectedExerciseId = globalStreams.selectedExerciseStream.latestValue;
      final isAtSelection = state.matchedLocation == '/trainingSelection';
      final isAtSession = state.matchedLocation == '/trainingSession';

      // If there is a selected exercise and we're at the selection screen, go to session.
      if (selectedExerciseId != null && isAtSelection) {
        return '/trainingSession';
      }
      // If there's no selected exercise but we're at the session screen, go back to selection.
      if (selectedExerciseId == null && isAtSession) {
        return '/trainingSelection';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: customShellRouteBuilder,
        routes: [
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: const SettingsScreen()),
          ),
          GoRoute(
            path: '/trainingSelection',
            name: 'trainingSelection',
            pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: const SelectTrainingView()),
          ),
          GoRoute(
            path: '/trainingSession',
            name: 'trainingSession',
            pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey,child: const ProcessTrainingView()),
          ),
          GoRoute(
            path: '/report',
            name: 'report',
            pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: const ReportScreen()),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) =>
              NoAnimationPage(key: state.pageKey, child: const HistoryScreen()),
          ),
        ],
      ),
    ],
  );
});

Widget customShellRouteBuilder(
    BuildContext context, GoRouterState state, Widget child) {
  return ProviderScope(
    child: ScreenWrapper(child: child),
  );
}

class NoAnimationPage<T> extends Page<T> {
  final Widget child;
  const NoAnimationPage({super.key, required this.child});
  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (_, __, ___) => child,
      transitionDuration: Duration.zero,
    );
  }
}
