import 'package:flutter/material.dart';
import 'dart:math' as math;

class InfoChartLastTrain extends StatelessWidget {
  final double minVal;
  final double maxVal;
  final int initialIndex;
  final int lastIndex;
  final bool decimal; 

  const InfoChartLastTrain({
    super.key,
    required this.minVal,
    required this.maxVal,
    this.initialIndex = 0,
    this.lastIndex = 4,
    this.decimal = true,
  }) : assert(minVal <= maxVal, 'minVal should not be greater than maxVal');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double height = 40.0;
    const double gap = 15.0;
    const int dotsNum = 5;

    const totalWidth = (gap + height) * dotsNum;

    List<double> positions = List.generate(dotsNum, (i) => i * (height + gap) + gap);

    final double scaledMinPos = positions[initialIndex];
    final double scaledMaxPos = positions[lastIndex];
    final double rangeBarWidth = maxVal == minVal ? height : scaledMaxPos - scaledMinPos + height;

    List<Widget> dots = List.generate(dotsNum, (j) {
      return Positioned(
        left: positions[j],
        child: _buildDot(theme),
      );
    });

    return Container(
      width: totalWidth,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...dots,
          _buildRangeBar(theme, scaledMinPos, rangeBarWidth),
          Positioned(
            left: 9 + scaledMinPos,
            top: 13,
            child: _buildLabel(theme, _formatNumber(minVal), true),
          ),
          Positioned(
            left: 9 + scaledMaxPos,
            top: 13,
            child: _buildLabel(theme, _formatNumber(maxVal), minVal != maxVal),
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
        height: 40,
        decoration: BoxDecoration(
          color: theme.primaryColorDark,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildDot(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
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

  String _formatNumber(double number) {
    return decimal ? number.toStringAsFixed(1) : ' ${number.toInt().toString()}';
  }
}
