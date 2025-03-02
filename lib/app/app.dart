import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymini/app/router/router_provider.dart';
import 'package:gymini/presentation_layer/screens/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _showWelcomeScreen = true;

  void _startSignUpProcess() {
    setState(() {
      _showWelcomeScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the GoRouter instance from our routerProvider.
    final GoRouter router = ref.watch(routerProvider);

    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState authState) {
        if (_showWelcomeScreen) {
          return WelcomeScreen(onStartSignUp: _startSignUpProcess);
        }
        switch (authState.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: authState,
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Aun no tienes cuenta?'),
                  TextButton(
                    onPressed: () => authState.changeStep(AuthenticatorStep.signUp),
                    child: const Text('Registrate'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: authState,
              body: SignUpForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes una cuenta?'),
                  TextButton(
                    onPressed: () => authState.changeStep(AuthenticatorStep.signIn),
                    child: const Text('Iniciar Sesión'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: authState,
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: authState,
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: authState,
              body: const ConfirmResetPasswordForm(),
            );
          default:
            return null; // Let the authenticator handle any unexpected steps.
        }
      },
      child: MaterialApp.router(
        title: 'Gymini',
        routerConfig: router, // Use the router instance.
        builder: Authenticator.builder(),
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        locale: const Locale('en', 'US'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit*4, horizontal: GyminiTheme.leftOuterPadding*2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App logo
              Padding(
                padding: EdgeInsets.only(top: GyminiTheme.verticalGapUnit*8),
                child: Center(child: 
                SizedBox(
                      //width: 28,
                      height: 100,
                      child: SvgPicture.asset('assets/icons/gymini_logo.svg'),
                    ),),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}