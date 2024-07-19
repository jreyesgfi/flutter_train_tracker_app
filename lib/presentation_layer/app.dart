import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp.router(
        title: 'Gymini',
        routerConfig: router,
        builder: Authenticator.builder(),
        theme: AppTheme.theme,
      ),
    );
  }
}
