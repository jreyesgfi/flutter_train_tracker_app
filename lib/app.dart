import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/screens/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/router/router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool _showWelcomeScreen = true; // Initially show the WelcomeScreen

  void _startSignUpProcess() {
    setState(() {
      _showWelcomeScreen = false; // Hide the WelcomeScreen and show sign-up
    });
  }
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        if (_showWelcomeScreen) {
          return WelcomeScreen(onStartSignUp: _startSignUpProcess);
        }
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign In form from amplify_authenticator
              body: SignInForm(),
              // A custom footer with a button to take the user to sign up
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Aun no tienes cuenta?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Registrate'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Sign Up form from amplify_authenticator
              body: SignUpForm(),
              // A custom footer with a button to take the user to sign in
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes una cuenta?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.confirmSignUp:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Sign Up form from amplify_authenticator
              body: ConfirmSignUpForm(),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Reset Password form from amplify_authenticator
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              // A prebuilt Confirm Reset Password form from amplify_authenticator
              body: const ConfirmResetPasswordForm(),
            );
          default:
            // Returning null defaults to the prebuilt authenticator for all other steps
            return null;
        }
      },

      child: ProviderScope(
        child: MaterialApp.router(
          title: 'Gymini',
          routerConfig: router,
          builder: Authenticator.builder(),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
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