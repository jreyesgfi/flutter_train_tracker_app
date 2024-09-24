import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/modals_snackbars/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final dataStoreServiceProvider = Provider<DataStoreService>((ref) {
//   return DataStoreService();
// });

// class DataStoreService {
//   Future<void> triggerDataStoreSync() async {
//     try {
//       await Amplify.DataStore.start();
//       // Implement any additional logic here if needed
//     } catch (e) {
//       // Handle exceptions
//       print("Error starting DataStore sync: $e");
//     }
//   }

//   // Optionally, method to monitor sync or handle other related logic
// }

Future<void> triggerDataStoreSync(BuildContext context) async {
  forceResync();
  showWarningSnackbar(context: context, message: "¡Sincronización completada!");
  // StreamSubscription<HubEvent>? hubSubscription;

  // void stopAndCleanUp() {
  //   Amplify.DataStore.stop().then((_) {
  //     print("DataStore sync stopped.");
  //   }).catchError((error) {
  //     print("Error stopping DataStore: $error");
  //   }).whenComplete(() {
  //     if (hubSubscription != null) {
  //       hubSubscription.cancel();
  //       print("Hub subscription cancelled.");
  //     }
  //   });
  // }

  // try {
  //   // Set up the Hub listener for DataStore events
  //   hubSubscription = Amplify.Hub.listen(
  //       HubChannel.DataStore as HubChannel<dynamic, HubEvent>,
  //       (dynamic hubEvent) async {
  //     print('Hub event received: ${hubEvent.eventName}, ${hubEvent.payload}');
  //     if (hubEvent.eventName == 'syncQueriesReady') {
  //       if (context.mounted) {
  //         showWarningSnackbar(
  //             context: context, message: "¡Sincronización completada!");
  //       }
  //       stopAndCleanUp();
  //     }
  //   });

  //   // Start the DataStore
  //   await Amplify.DataStore.start();
  //   if (context.mounted) {
  //     showWarningSnackbar(context: context, message: "Sincronización iniciada");
  //   }
  // } catch (e) {
  //   print("An error occurred during DataStore sync setup: $e");
  //   // Attempt to stop DataStore and cancel the Hub subscription on error
  //   await Amplify.DataStore.stop();
  //   await hubSubscription?.cancel();
  // }
}

Future<void> signOut(BuildContext context) async {
  try {
    await Amplify.DataStore.clear();
    await Amplify.Auth.signOut();
    if(context.mounted){
      Navigator.of(context).pop();
    }
  } catch (e) {
    print('Sign out failed: $e');
  }
}

Future<void> forceResync() async {
  try {
    // Clear the local DataStore
    await Amplify.DataStore.clear();
    print("DataStore cleared successfully.");

    // Restart the DataStore to re-sync from the cloud
    await Amplify.DataStore.start();
    print("DataStore sync started.");
  } catch (e) {
    print("Error during resync process: $e");
  }
}