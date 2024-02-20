import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_application_test1/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  try {
    await Amplify.addPlugins([authPlugin]);
    await Amplify.configure(amplifyconfig); // 'amplifyconfig' is defined in 'amplifyconfiguration.dart'
    print('Successfully configured Amplify 🎉');
    setState(() {
      _amplifyConfigured = true;
    });
  } on AmplifyAlreadyConfiguredException {
    //Amplify already created
  } catch (e) {
    //Error message
  }
}

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}