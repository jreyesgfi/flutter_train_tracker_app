import 'package:gymini/presentation_layer/screens/screen_wrapper.dart';
import 'package:gymini/presentation_layer/screens/signup_screen.dart';
import 'package:gymini/common_layer/utils/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                controller: _emailController,
                validator: (value) =>
                    !validateEmail(value) ? "Email is Invalid" : null,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: _passwordController,
                validator: (value) =>
                    value?.isEmpty ?? false ? "Password is invalid" : null,
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                child: Text("LOG IN"),
                onPressed: () => _loginButtonOnPressed(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              OutlinedButton(
                child: Text("Create New Account"),
                onPressed: () => _gotoSignUpScreen(context),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  side: MaterialStateProperty.all(BorderSide(
                      color:
                          Theme.of(context).primaryColor)), // For border color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginButtonOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Request to Amplify for signing in
        final SignInResult signInResult = await Amplify.Auth.signIn(
          username: email,
          password: password,
        );

        if (signInResult.isSignedIn) {
          // User is now signed in; navigate to the app's home or a landing page
          // This could be a main screen or dashboard for authenticated users
          // Implement your own navigation method or screen transition
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => ScreenWrapper()));
        } else {
          // Could provide generic message or action for non-completed login,
          // e.g., request more login methods or perform a 2FA step if required
          print("An unknown authentication state was returned.");
        }
      } on AuthException catch (e) {
        // e.message contains error data; you might want to display this to the end user
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  void _gotoSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpScreen(),
      ),
    );
  }
}
