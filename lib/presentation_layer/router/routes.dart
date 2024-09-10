import 'package:flutter/material.dart';

enum AppRoute {
  settings,
  training,
  report,
  history,
}

class NavigationDestinationItem {
  final String? iconPath;
  final String? selectedIconPath;
  final IconData? icon;
  final IconData? selectedIcon;
  final String label;

  NavigationDestinationItem({
    this.iconPath,
    this.selectedIconPath,
    this.icon,
    this.selectedIcon,
    required this.label,
  });
}
final List<NavigationDestinationItem> navigationItems = [
  NavigationDestinationItem(
    iconPath: "assets/icons/profile.svg",
    selectedIconPath: "assets/icons/profile.svg",
    label: "Settings",
  ),
  NavigationDestinationItem(
    iconPath: "assets/icons/chrono.svg",
    selectedIconPath: "assets/icons/chrono.svg",
    label: "Training",
  ),
  NavigationDestinationItem(
    iconPath: "assets/icons/chart.svg",
    selectedIconPath: "assets/icons/chart.svg",
    label: "Statistics",
  ),
  NavigationDestinationItem(
    icon: Icons.format_list_bulleted,
    selectedIcon: Icons.format_list_bulleted,
    label: "History",
  ),
];
