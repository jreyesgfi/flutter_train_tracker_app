import 'package:flutter/material.dart';

void showWarningSnackbar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  String? dismissLabel,
  VoidCallback? action,
  Duration duration = const Duration(seconds: 8),
}) {
  if (!context.mounted) {
    return;
  }
  
  final actions = <SnackBarAction>[];

  if (actionLabel != null && action != null) {
    actions.add(
      SnackBarAction(
        label: actionLabel,
        onPressed: action,
      ),
    );
  }

  if (dismissLabel != null) {
    actions.add(
      SnackBarAction(
        label: dismissLabel,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Align(
        alignment: Alignment.centerLeft,
        child: Text(message),
      ),
      duration: duration,
      backgroundColor: Theme.of(context).primaryColorDark,
      action: actions.isNotEmpty ? actions.first : null,
    ),
  );
}
