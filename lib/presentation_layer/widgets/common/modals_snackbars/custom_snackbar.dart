import 'package:flutter/material.dart';

void showWarningSnackbar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? action,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: Theme.of(context).primaryColorDark,
      action: actionLabel != null && action != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: action,
            )
          : null,
    ),
  );
}
