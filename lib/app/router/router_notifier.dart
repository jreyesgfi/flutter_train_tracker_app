// lib/app/router/go_router_refresh_stream.dart
import 'dart:async';
import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
