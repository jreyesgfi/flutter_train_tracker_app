import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart'; // Your routes file

final routeProvider = StateProvider<String>((ref) => '');


class RouteUtils {
  // Dynamically create a map from route names to their indices based on AppRoute
  static final Map<String, int> routeToIndex = {
    for (int i = 0; i < navigationItems.length; i++)
      navigationItems[i].label : i
  };

  // Dynamically create a list that maps indices back to route names
  static final List<String> indexToRoute = [
    for (var route in AppRoute.values) route.name
  ];

  // Method to get the index from the route
  static int indexByRoute(String route) {
    return routeToIndex[route] ?? 1; // Default to index 1 (training)
  }

  // Method to get the route from the index
  static String routeByIndex(int index) {
    return indexToRoute[index];
  }
}

