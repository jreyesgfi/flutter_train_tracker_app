import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const mainTitle = TextStyle(
    fontSize: 28.0,
    letterSpacing: 0.38,
    height: 1.0, // Line height as a multiplier of font size
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const subtitle = TextStyle(
    fontSize: 18.0,
    letterSpacing: 0.38,
    height: 1.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const miniTitle = TextStyle(
    fontSize: 16.0,
    letterSpacing: 0.14,
    height: 1.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const comment = TextStyle(
    fontSize: 11.0,
    letterSpacing: 0.14,
    height: 1.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const body = TextStyle(
    fontSize: 13.0,
    letterSpacing: 0.13,
    height: 1.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const focus = TextStyle(
    fontSize: 20.0,
    letterSpacing: 0.32,
    height: 1.6,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const clock = TextStyle(
    fontSize: 28.0,
    letterSpacing: 4,
    height: 1.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );
}
