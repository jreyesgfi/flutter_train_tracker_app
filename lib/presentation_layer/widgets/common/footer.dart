import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/router/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';


final iconPaths = [
      "assets/icons/profile.svg",
      "assets/icons/chrono.svg",
      "assets/icons/chart.svg"
    ];
final iconLabels = ["Profile", "Chrono", "Chart" ];

class FooterNavigation extends StatefulWidget {
  const FooterNavigation({super.key});

  @override
  State<FooterNavigation> createState() => _FooterNavigationState();
}

class _FooterNavigationState extends State<FooterNavigation> {
  int selectedIndex = 1; 

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.goNamed(AppRoute.profile.name);
        break;
      case 1:
        context.goNamed(AppRoute.train.name);
        break;
      case 2:
        context.goNamed(AppRoute.report.name);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) => _buildTabItem(index, context)),
      ),
    );
  }

  Widget _buildTabItem(int index, BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: isSelected ? 60 : 45,
        width: isSelected ? 60 : 45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SvgPicture.asset(
                iconPaths[index],
                colorFilter: ColorFilter.mode(
                  isSelected ? theme.primaryColor : theme.primaryColorDark, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
