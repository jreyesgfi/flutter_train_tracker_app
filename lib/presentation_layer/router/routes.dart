enum AppRoute {
  profile,
  training,
  report,
}

class NavigationDestinationItem {
  final String iconPath;
  final String selectedIconPath;
  final String label;

  NavigationDestinationItem({
    required this.iconPath,
    required this.selectedIconPath,
    required this.label,
  });
}

final List<NavigationDestinationItem> navigationItems = [
  NavigationDestinationItem(
    iconPath: "assets/icons/profile.svg",
    selectedIconPath: "assets/icons/profile.svg",
    label: "Profile",
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
];