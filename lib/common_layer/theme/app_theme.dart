import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      // Color setup
      primaryColor: AppColors.primaryColor,
      primaryColorDark: AppColors.darkColor,
      primaryColorLight: AppColors.lightColor,
      shadowColor: AppColors.greyColor,
      highlightColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.accentColor),

      // TextStyle setup
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.mainTitle, // Typically used for large text in displays
        bodySmall: AppTextStyles.body, // Standard body text
        titleMedium: AppTextStyles.subtitle, // Smaller than headline but larger than body text
        titleSmall: AppTextStyles.miniTitle,
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        color: AppColors.primaryColor,
        // titleTextStyle: TextTheme(
        //   headline6: AppTextStyles.mainTitle, // Used for titles in AppBar (older Flutter versions might use title instead of headline6)
        // ),
      ),

      // Button theme
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.accentColor,
        textTheme: ButtonTextTheme.primary,
      ),

      // Input Decoration theme for text form fields
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.greyColor),
        hintStyle: TextStyle(color: AppColors.lightColor),
      ),
    );
  }
}
