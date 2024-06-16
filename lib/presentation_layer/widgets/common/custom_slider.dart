import 'package:flutter/material.dart';
import 'dart:math' as math;

class InfoChartLastTrain extends StatelessWidget {
  final int minVal;
  final int maxVal;
  final bool right;

  const InfoChartLastTrain({
    super.key,
    required this.minVal,
    required this.maxVal,
    this.right = true,
  }) : assert(minVal <= maxVal, 'minVal should not be greater than maxVal');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double height = 32.0;
    const double gap = 16.0;
    const int dotsNum = 6;

    const width = (gap + height) * dotsNum;
    final int range = math.min(maxVal - minVal, 2);
    final double rangeBarWidth = range * (height + gap) + height;

    List<double> positions = List.generate(dotsNum, (i) => i * (height + gap) + gap);

    final int initialIndex = (right == true ? 3 : 2) - (range == 2 ? 1 : 0);
    final double scaledMinPos = positions[initialIndex];
    final double scaledMaxPos = positions[initialIndex + range];
    debugPrint('${right ? 3 : 2 }');
    debugPrint('${(range == 2 ? 1 : 0)}');
    debugPrint('${(right ? 3 : 2) - (range == 2 ? 1 : 0)}\n');
    List<Widget> dots = List.generate(dotsNum, (j) {
      return Positioned(
        left: positions[j],
        child: _buildDot(theme),
      );
    });

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...dots,
          _buildRangeBar(theme, scaledMinPos, rangeBarWidth),
          Positioned(
            left: 9+scaledMinPos,
            top: 8,
            child: _buildLabel(theme, minVal.toString(), minVal != maxVal),
          ),
          Positioned(
            left: 9+scaledMaxPos,
            top: 8,
            child: _buildLabel(theme, maxVal.toString(), true),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeBar(ThemeData theme, double start, double width) {
    return Positioned(
      left: start,
      width: width,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: theme.primaryColorDark,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildDot(ThemeData theme) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLabel(ThemeData theme, String text, bool visible) {
    if (!visible) return const SizedBox.shrink();
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.scaffoldBackgroundColor),
    );
  }
}
