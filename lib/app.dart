import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: ProviderScope(
        child: MaterialApp.router(
          title: 'Gymini',
          routerConfig: router,
          builder: Authenticator.builder(),
          theme: AppTheme.theme,
          supportedLocales: const [
            Locale('en', 'US'),  // English
            Locale('es', 'ES'),  // Spanish
          ],
          locale: const Locale('en', 'US'),  // Default locale
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            MonthYearPickerLocalizations.delegate, 
          ],
        ),
      ),
    );
  }
}