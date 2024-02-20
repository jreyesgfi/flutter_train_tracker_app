import 'package:flutter_application_test1/screens/signup_screen.dart';
import 'package:flutter_application_test1/utils/email_validator.dart';
import 'package:flutter/material.dart';

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
                    foregroundColor:
                      MaterialStateProperty.all(Colors.white),
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
      //TODO: Login code
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
