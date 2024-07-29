import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/ModelProvider.dart';
import 'package:flutter_application_test1/app.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(modelProvider: ModelProvider.instance),
      AmplifyDataStore(modelProvider: ModelProvider.instance),
    ]);
    await Amplify.configure(amplifyconfig); 
    await Amplify.DataStore.stop();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify was already configured.');
  } catch (e) {
    debugPrint("Failed to configure Amplify: $e");
  }
}
