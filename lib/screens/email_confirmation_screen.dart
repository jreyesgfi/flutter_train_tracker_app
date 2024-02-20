import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter_application_test1/screens/main_screen.dart';
import 'package:flutter/material.dart';

class EmailConfirmationScreen extends StatelessWidget {
  final String email;

  EmailConfirmationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _confirmationCodeController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirm your email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "An email confirmation code is sent to $email. Please type the code to confirm your email.",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _confirmationCodeController,
                decoration: InputDecoration(labelText: "Confirmation Code"),
                validator: (value) => value?.length != 6
                    ? "The confirmation code is invalid"
                    : null,
              ),
              ElevatedButton(
                onPressed: () => _submitCode(context),
                child: Text("CONFIRM"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitCode(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final confirmationCode = _confirmationCodeController.text;
      try {
        final SignUpResult response = await Amplify.Auth.confirmSignUp(
          username: email,
          confirmationCode: confirmationCode,
        );
        debugPrint(response.toString());
        if (response.isSignUpComplete) {
          _gotoMainScreen(context);
        }
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(e.message), // Use e.message to display the error message.
          ),
        );
      }
    }
  }

  void _gotoMainScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MainScreen()));
  }
}
