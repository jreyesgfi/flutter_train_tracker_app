import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/custom_colors.dart';
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
      title: 'Login Demo',
      theme: ThemeData(
          primaryColor: Colors.orange.shade700,
          primaryColorLight: Colors.orange.shade50,
          hintColor: Colors.orange.shade200,
          primaryColorDark: Color.fromARGB(255, 12, 6, 0),
          primarySwatch: Colors.orange,
          cardColor: Colors.orange.shade50,
          canvasColor: Color.fromARGB(120, 230, 230, 233),
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Color.fromARGB(252, 252, 252, 255),
            primarySwatch: Colors.orange, // Your primary swatch
            accentColor: Colors.orange.shade700, // Your accent color
            cardColor: Color.fromARGB(231, 255, 255, 255),
          ),
          
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle:
                TextStyle(color: Color.fromARGB(255, 0, 27, 44)), // Label color
            hintStyle: TextStyle(color: Colors.orange.shade700),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Color.fromARGB(255, 0, 6, 10)),
            bodyLarge: TextStyle(
                color:
                    Color.fromARGB(255, 0, 6, 10)), // Default body text style
            bodyMedium: TextStyle(
                color:
                    Color.fromARGB(255, 0, 6, 10)), // Default body text style
            displayMedium: TextStyle(color: Color.fromARGB(255, 0, 6, 10)),
            displayLarge: TextStyle(color: Color.fromARGB(255, 0, 6, 10)),
            displaySmall: TextStyle(color: Color.fromARGB(255, 0, 6, 10)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0, // Remove shadow
              backgroundColor:
                  Colors.orange.shade700, // Background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
          extensions: const <ThemeExtension<dynamic>>[
            CustomColors(
              greyColor: Color.fromARGB(255, 192, 192, 192),
              greenColor: Color.fromARGB(255, 105, 202, 108),
            ),
          ]),
      home: MyHomePage(title: 'Login Demo'),
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
              return WidgetTestingScreen(); // Navigate to the MainScreen if the user is logged in
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
