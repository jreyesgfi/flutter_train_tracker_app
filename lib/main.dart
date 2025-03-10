// lib/app/main.dart
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gymini/infrastructure_layer/config/local_database_helper.dart';
import 'package:gymini/models/ModelProvider.dart';
import 'package:gymini/app/app.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Amplify
  await _configureAmplify();

  // Initialize Local Database
  await _initializeDatabase();

  // Run the App wrapped in ProviderScope.
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(),
      AmplifyDataStore(modelProvider: ModelProvider.instance),
    ]);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify was already configured.');
  } catch (e) {
    debugPrint("Failed to configure Amplify: $e");
  }
}

Future<void> _initializeDatabase() async {
  try {
    await DatabaseHelper().database;
    debugPrint("Local database initialized successfully.");
  } catch (e) {
    debugPrint("Failed to initialize the local database: $e");
  }
}
