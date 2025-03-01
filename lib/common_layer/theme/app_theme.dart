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
      var lerpedBorderRadius = lerpDouble(
          properties.borderRadius, other.properties.borderRadius, t)!;
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

final customThemeValues = CustomThemeValues(borderRadius: 16.0);

class GyminiTheme {
  GyminiTheme._();
  // Space
  static double leftOuterPadding = 32;
  static double rightOuterPadding = 16;
  static double leftInnerPadding = 12;
  static BorderRadius circularBorderRadius = BorderRadius.circular(16);

  static double verticalGapUnit = 8;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
        // Color setup
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.darkColor,
        primaryColorLight: AppColors.primaryColorLight,
        shadowColor: AppColors.greyColor,
        highlightColor: AppColors.accentColor,
        scaffoldBackgroundColor: AppColors.primaryColorLight,
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: AppColors.accentColor),

        // TextStyle setup
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          titleLarge: AppTextStyles
              .mainTitle, // Typically used for large text in displays
          titleMedium: AppTextStyles
              .subtitle, // Smaller than headline but larger than body text
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
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors
                .primaryColor, // Set primary color for button background
            foregroundColor: Colors.white, // Button text color
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
  backgroundColor: AppColors
                    .primaryColor,  // Default: Material's secondary color
  foregroundColor: AppColors.whiteColor,  // Default: Text/icon color
  hoverColor: AppColors
                    .primaryColor.withOpacity(0.8),  // Default hover color
  splashColor: Colors.white.withOpacity(0.2),  // Splash effect color
),
        filledButtonTheme: FilledButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors
                    .primaryColor),  // Default primary color
    foregroundColor: WidgetStateProperty.all(AppColors
                    .whiteColor),  // Default text color
    overlayColor: WidgetStateProperty.all(AppColors
                    .primaryColor.withOpacity(0.1)),  // Ripple effect
  ),
),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
                color: AppColors
                    .primaryColor), // Border color for outlined buttons
            foregroundColor:
                AppColors.primaryColor, // Text color for outlined buttons
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.darkColor,
              textStyle: AppTextStyles.miniTitle),
        ),

        // Input decoration (e.g., for text fields)
        inputDecorationTheme: InputDecorationTheme(
          // Style for text fields
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors
                  .darkColor, // Set dark color for underline when focused
              width: 2.0, // Thickness of the underline
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors
                  .darkColor, // Set dark color for underline when enabled but not focused
              width: 1.5,
            ),
          ),
          labelStyle: const TextStyle(
            color: AppColors.darkColor, // Set primary color for label text
          ),
          hintStyle: TextStyle(
            color: AppColors.greyColor
                .withOpacity(0.6), // Lighter primary color for hints
          ),
        ),

        // extensions
        extensions: const <ThemeExtension<dynamic>>[
          CustomTheme(
            properties: CustomThemeProperties(
              borderRadius: 16.0,
            ),
          ),
        ]);
  }
}
