
import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color greyColor;
  final Color greenColor;

  const CustomColors({
    this.greyColor = Colors.grey,
    this.greenColor = Colors.green
    });

  @override
  CustomColors copyWith({Color? greyColor, Color? greenColor}) {
    return CustomColors(
      greyColor: greyColor ?? this.greyColor,
      greenColor: greenColor ?? this.greenColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      greyColor: Color.lerp(this.greyColor, other.greyColor, t)!,
    );
  }
}
extension CustomTheme on BuildContext {
  CustomColors get customColors {
    final customColors = Theme.of(this).extension<CustomColors>();
    assert(customColors != null, 'CustomColors is not found in the current theme');
    return customColors!;
  }
}