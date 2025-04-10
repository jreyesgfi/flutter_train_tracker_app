import 'package:flutter/material.dart';

class CustomLegend extends StatelessWidget {
  final List<String> items;
  final List<Color>? colors;
  final double itemSpacing;
  final double iconSize;
  final TextStyle? textStyle;

  const CustomLegend({
    super.key,
    required this.items,
    this.colors,
    this.itemSpacing = 16.0,
    this.iconSize = 12.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Default colors if none are provided.
    final defaultColors = [
      Theme.of(context).primaryColorDark,
      Theme.of(context).primaryColor
    ];

    // Use provided colors or the default ones.
    final effectiveColors = colors ?? defaultColors;

    // Build the legend items in a row.
    List<Widget> legendWidgets = [];
    for (int i = 0; i < items.length; i++) {
      // Use modulo to cycle through colors if there are fewer colors than items.
      final color = effectiveColors[i % effectiveColors.length];
      legendWidgets.add(
        Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              items[i],
              style: textStyle ?? const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
      if (i < items.length - 1) {
        legendWidgets.add(SizedBox(width: itemSpacing));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: legendWidgets,
      ),
    );
  }
}
