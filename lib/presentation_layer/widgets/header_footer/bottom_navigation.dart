import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 1; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.goNamed(AppRoute.settings.name);
        break;
      case 1:
        context.goNamed(AppRoute.training.name);
        break;
      case 2:
        context.goNamed(AppRoute.report.name);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      destinations: navigationItems.map((item) => NavigationDestination(
        icon: SizedBox(
          width: 32, // Normal icon size
          height: 32,
          child: SvgPicture.asset(
            item.iconPath,
            colorFilter: ColorFilter.mode(theme.primaryColorDark, BlendMode.srcIn),
          ),
        ),
        selectedIcon: SizedBox(
          width: 44, // Larger icon size when selected
          height: 44,
          child: SvgPicture.asset(
            item.selectedIconPath,
            colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn),
          ),
        ),
        label: item.label,
      )).toList(),
      backgroundColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: Colors.transparent,
    );
  }
}

// destinations: List.generate(navigationItems.length, (index) {
//         final isItemSelected = index == _selectedIndex;
//         final scaleFactor = isItemSelected ? 1.2 : 1.0;
//         return NavigationDestination(
//           icon: Transform.scale(
//             scale: scaleFactor,
//             child: SvgPicture.asset(
//               navigationItems[index].iconPath,
//               colorFilter: ColorFilter.mode(theme.primaryColorDark, BlendMode.srcIn)
//             ),
//           ),
//           selectedIcon: Transform.scale(
//             scale: scaleFactor,
//             child: SvgPicture.asset(
//               navigationItems[index].selectedIconPath,
//               colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn)
//             ),
//           ),
//           label: navigationItems[index].label,
//         );
//       }),
