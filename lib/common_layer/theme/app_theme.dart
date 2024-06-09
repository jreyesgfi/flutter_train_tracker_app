import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // Colors
      primaryColor: AppColors.primaryColor,
      primaryColorLight: AppColors.lightColor,
      primaryColorDark: AppColors.darkColor,
      hintColor: AppColors.greyColor,
      cardColor: AppColors.whiteColor,
      canvasColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: AppColors.backgroundColor,
        primarySwatch: Colors.orange, // Adjust based on AppColors if needed
        accentColor: AppColors.accentColor,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.textColor),
        hintStyle: TextStyle(color: AppColors.accentColor),
      ),

      // TEXT
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: AppColors.textColor),
        bodyLarge: TextStyle(color: AppColors.textColor),
        bodyMedium: TextStyle(color: AppColors.textColor),
        displayMedium: TextStyle(color: AppColors.textColor),
        displayLarge: TextStyle(color: AppColors.textColor),
        displaySmall: TextStyle(color: AppColors.textColor),
      ),

      // BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),

    );
  }
}