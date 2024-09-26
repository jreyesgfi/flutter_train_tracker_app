import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/presentation_layer/router/navitation_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymini/presentation_layer/router/routes.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        NavigationUtils.navigateWithDelay(ref, context, AppRoute.settings);
        break;
      case 1:
        NavigationUtils.navigateWithDelay(
            ref, context, AppRoute.trainingSelection);
        break;
      case 2:
        NavigationUtils.navigateWithDelay(ref, context, AppRoute.report);
        break;
      case 3:
        NavigationUtils.navigateWithDelay(ref, context, AppRoute.history);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(100, 30),
              topRight: Radius.elliptical(100, 30)),
          color: AppColors.bottomBarColor,
        ),
        child: NavigationBar(
          shadowColor: Colors.transparent,
          overlayColor: WidgetStateColor.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: navigationItems
              .where((item) => item.displayed == true)
              .map((item) => NavigationDestination(
                    icon: SizedBox(
                      width: 28, // Normal icon size
                      height: 28,
                      child: item.iconPath != null
                          ? SvgPicture.asset(
                              item.iconPath!,
                              colorFilter: ColorFilter.mode(
                                  theme.primaryColorDark, BlendMode.srcIn),
                            )
                          : Icon(item.icon, size: 24),
                    ),
                    selectedIcon: SizedBox(
                      width: 40,
                      height: 40,
                      child: item.iconPath != null
                          ? SvgPicture.asset(
                              item.selectedIconPath!,
                              colorFilter: ColorFilter.mode(
                                  theme.primaryColor, BlendMode.srcIn),
                            )
                          : Icon(
                              item.selectedIcon,
                              color: theme.primaryColor,
                              size: 36,
                            ),
                    ),
                    label: item.label,
                  ))
              .toList(),
          backgroundColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.transparent,
        ));
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
