import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


final iconPaths = [
      "assets/icons/chart.svg",
      "assets/icons/chrono.svg",
      "assets/icons/profile.svg"
    ];
final iconLabels = ["Chart", "Chrono", "Profile"];

class FooterNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped; 

  const FooterNavigation({
    super.key,
    this.selectedIndex = 0,
    required this.onTabTapped
  });

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
        height: isSelected ? 60 : 45, // Animated height change
        width: isSelected ? 60 : 45, // Animated width change
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( // Use Expanded to make SVG scale with AnimatedContainer
              child: SvgPicture.asset(
                iconPaths[index],
                colorFilter: ColorFilter.mode(
                  isSelected ? theme.primaryColor : theme.primaryColorDark, BlendMode.srcIn),
                fit: BoxFit.contain, // Ensure the SVG scales correctly
              ),
            ),
            // Text(
            //   iconLabels[index],
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: isSelected ? theme.primaryColor : theme.primaryColorDark,
            //   ),
            // )
          ],
        ),
      )
    );
}


}
