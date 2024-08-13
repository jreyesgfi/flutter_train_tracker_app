import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'dart:ui';

// Custom properties class
class CustomThemeProperties {
  final double borderRadius;

  const CustomThemeProperties({
    required this.borderRadius,
  });
}

// Extension
class CustomTheme extends ThemeExtension<CustomTheme> {
  final CustomThemeProperties properties;

  const CustomTheme({required this.properties});

  @override
  CustomTheme copyWith({CustomThemeProperties? properties}) {
    return CustomTheme(
      properties: properties ?? this.properties,
    );
  }

  @override
  CustomTheme lerp(ThemeExtension<CustomTheme>? other, double t) {
    if (other is CustomTheme) {
      var lerpedBorderRadius = lerpDouble(this.properties.borderRadius, other.properties.borderRadius, t)!;
      return CustomTheme(
        properties: CustomThemeProperties(borderRadius: lerpedBorderRadius),
      );
    }
    return this;
  }
}

class CustomThemeValues {
  final double borderRadius;

  CustomThemeValues({
    required this.borderRadius,
  });
}

final customThemeValues = CustomThemeValues(
  borderRadius: 16.0
);

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
        titleMedium: AppTextStyles.subtitle, // Smaller than headline but larger than body text
        titleSmall: AppTextStyles.miniTitle,
        bodyLarge: AppTextStyles.focus,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.comment, // Standard body text
        headlineLarge: AppTextStyles.clock,
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

      // extensions
      extensions: const <ThemeExtension<dynamic>>[
        CustomTheme(
          properties: CustomThemeProperties(
            borderRadius: 16.0,
          ),
        ),
      ]
    );
  }
}


