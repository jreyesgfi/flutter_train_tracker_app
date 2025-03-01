import 'package:flutter/material.dart';
import 'package:gymini/infrastructure_layer/network/amplify_service.dart';


void showSignOutDialog(BuildContext context) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
              'Cerrar Sesión',
              style: theme.textTheme.titleMedium!.copyWith(color: theme.primaryColorDark),
        ),
        content: Text(
              '¿Estás seguro de que quieres cerrar sesión?',
              style: theme.textTheme.bodyMedium!.copyWith(color: theme.primaryColorDark),
        ),
        
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async{
              signOut(context);
            },
            child: Text('Cerrar Sesión', style: TextStyle(color: theme.primaryColor)),
          ),
        ],
      );
    },
  );
}
