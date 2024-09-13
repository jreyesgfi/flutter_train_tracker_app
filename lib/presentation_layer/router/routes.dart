import 'package:flutter/material.dart';

enum AppRoute {
  settings,
  trainingSelection,
  report,
  history,
  // not included in navigation
  trainingSession,
}

enum AppSubRoute {
  trainingSelection,
  trainingSession,
}

class NavigationDestinationItem {
  final String? iconPath;
  final String? selectedIconPath;
  final IconData? icon;
  final IconData? selectedIcon;
  final String label;
  final bool displayed;

  NavigationDestinationItem({
    this.iconPath,
    this.selectedIconPath,
    this.icon,
    this.selectedIcon,
    this.displayed= true,
    required this.label,
  });
}
final List<NavigationDestinationItem> navigationItems = [
  NavigationDestinationItem(
    iconPath: "assets/icons/profile.svg",
    selectedIconPath: "assets/icons/profile.svg",
    label: "Ajustes",
  ),
  NavigationDestinationItem(
    iconPath: "assets/icons/chrono.svg",
    selectedIconPath: "assets/icons/chrono.svg",
    label: "Nuevo Entrenamiento",
  ),
  NavigationDestinationItem(
    iconPath: "assets/icons/chart.svg",
    selectedIconPath: "assets/icons/chart.svg",
    label: "Estadísticas",
  ),
  NavigationDestinationItem(
    icon: Icons.format_list_bulleted,
    selectedIcon: Icons.format_list_bulleted,
    label: "Registro",
  ),

  //not displayed in the navigation bar
  NavigationDestinationItem(
    iconPath: "assets/icons/chrono.svg",
    selectedIconPath: "assets/icons/chrono.svg",
    label: "Nuevo Entrenamiento",
    displayed: false,
  ),
];
