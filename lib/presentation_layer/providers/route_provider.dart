import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/app/router/routes.dart'; // Your routes file

final routeProvider = StateProvider<AppRoute>((ref) => AppRoute.trainingSelection);

