import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final int min;
  final int max;

  const CustomSlider({
    super.key,
    required this.min,
    required this.max,
  }) : assert(min <= max, 'min should not be greater than max');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const width = 200.0;
    final scale = max + ((max - min) / 2) + 2;
    final double scaledMin = (min / scale) * width;
    final double scaledMax = (max / scale) * width;

    return Container(
      width: width+20,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundBar(theme),
          _buildRangeBar(theme, scaledMin, scaledMax),
          Positioned(
            left: scaledMin,
            top: 0,
            child: _buildLabel(theme, min.toString(), min != max),
          ),
          Positioned(
            left: scaledMax,
            top: 0,
            child: _buildLabel(theme, max.toString(), true),
          ),
          Positioned(
            left: scaledMin,
            child: _buildDot(theme),
          ),
          Positioned(
            left: scaledMax,
            child: _buildDot(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBar(ThemeData theme) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: theme.primaryColorLight,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeBar(ThemeData theme, double scaledMin, double scaledMax) {
    if (min == max) return const SizedBox();
    return Positioned(
      left: scaledMin+5,
      width: scaledMax - scaledMin+5,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: theme.shadowColor,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildDot(ThemeData theme) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: theme.primaryColorDark,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLabel(ThemeData theme, String text, bool visible) {
    if (!visible) return const SizedBox();
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColorDark),
    );
  }
}
