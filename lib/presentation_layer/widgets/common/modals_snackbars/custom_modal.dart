import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  required String message,
  String? title,
  String? actionLabel,
  String? dismissLabel,
  VoidCallback? action,
}) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title != null
            ? Text(
                title,
                style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColorDark),
              )
            : null,
        content: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(color: theme.primaryColorDark),
        ),
        actions: <Widget>[
          if (dismissLabel != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text(dismissLabel),
            ),
          if (actionLabel != null && action != null)
            TextButton(
              onPressed: () async {
                action();
                Navigator.of(context).pop(); // Close the dialog after action
              },
              child: Text(actionLabel, style: TextStyle(color: theme.primaryColor)),
            ),
        ],
      );
    },
  );
}
