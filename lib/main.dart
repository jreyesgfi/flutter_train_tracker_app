import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/screens/training_selection_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/widget_testing_screen.dart';
import 'infrastructure_layer/config/amplifyconfiguration.dart';
import 'package:flutter_application_test1/presentation_layer/screens/login_screen.dart';
import 'package:flutter_application_test1/presentation_layer/screens/main_screen.dart'; // Make sure you have this import for MainScreen
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_application_test1/models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymiphy',
       theme: AppTheme.theme, // Use the centralized theme
      home: MyHomePage(title: 'Gymiphy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);

    try {
      await Amplify.addPlugins([authPlugin, datastorePlugin]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      // Amplify was already configured. This is fine since we're likely in hot reload/restart.
    } catch (e) {
      print("An error occurred configuring Amplify: $e");
    }
  }

  Future<bool> _checkUserLoggedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } catch (e) {
      print("Error checking logged in user: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_amplifyConfigured) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return FutureBuilder<bool>(
        future: _checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // User is logged in
              return TestingScreen(); // Navigate to the MainScreen if the user is logged in
            } else {
              // User is not logged in or error in fetching session
              return LoginScreen(); // Navigate to the LoginScreen if the user is not logged in
            }
          } else {
            // Waiting for future to complete (i.e., checking login state)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    }
  }
}
