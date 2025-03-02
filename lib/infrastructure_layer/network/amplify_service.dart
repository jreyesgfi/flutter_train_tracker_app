import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gymini/app/router/navitation_utils.dart';
import 'package:gymini/presentation_layer/widgets/common/modals_snackbars/custom_snackbar.dart';

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
  resetApp(context);
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
    if (context.mounted) {
      resetApp(context);
    }
    await Amplify.Auth.signOut();
    
  } catch (e) {
    if(context.mounted){
      showWarningSnackbar(context:context, message: 'Sign out failed: $e');
    }
  }
}

Future<void> resync() async {
  // Clear DataStore
  await Amplify.DataStore.clear();
  //print("DataStore cleared successfully.");

  // Start DataStore again
  await Amplify.DataStore.start();
  //print("DataStore sync started.");

}
Future<void> resetApp(BuildContext context) async {
  await resync();
  try {
    if (context.mounted){
      NavigationUtils.resetAppNavigation(context);
    }
  } catch (e) {
    if(context.mounted){
      showWarningSnackbar(context:context, message: "Error during resync process: $e");
    }
  }
}