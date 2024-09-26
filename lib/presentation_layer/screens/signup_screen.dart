import 'package:gymini/presentation_layer/temp/email_confirmation_screen.dart';
import 'package:gymini/common_layer/utils/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                validator: (value) => value?.isEmpty ?? true
                    ? "Password is invalid"
                    : value != null && value.length < 9
                        ? "Password must contain at least 8 characters"
                        : null,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text("CREATE ACCOUNT"),
                onPressed: () => _createAccountOnPressed(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  // If you want to adjust the text color based on the background color's brightness, you can do it like this:
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAccountOnPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // TODO: Implment sign-up process
      try {
        final SignUpResult result = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: SignUpOptions(
            userAttributes: {
              AuthUserAttributeKey.email: email,
            },
          ),
        );

        _goToEmailConfirmationScreen(context, email);
      } on AuthException catch (e) {
        final snackBar = SnackBar(content: Text(e.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _goToEmailConfirmationScreen(BuildContext context, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailConfirmationScreen(email: email),
      ),
    );
  }
}
