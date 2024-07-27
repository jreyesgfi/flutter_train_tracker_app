import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/modals/sign_out_modal.dart';

class SettingItem {
  final IconData icon;
  final String label;
  final Function(BuildContext) onTap;

  SettingItem({required this.icon, required this.label, required this.onTap});
}

class SettingGroup {
  final String title;
  final List<SettingItem> items;

  SettingGroup({required this.title, required this.items});
}

final List<SettingGroup> settingsGroups = [
  SettingGroup(
    title: 'Cuenta',
    items: [
      SettingItem(
        icon: Icons.account_circle,
        label: 'Información de la cuenta',
        onTap: (context) {
          // Navigation or action
        },
      ),
      SettingItem(
        icon: Icons.group,
        label: 'Comparte',
        onTap: (context) {
          // Navigation or action
        },
      ),
      SettingItem(
        icon: Icons.exit_to_app,
        label: 'Cerrar Sesión',
        onTap: (context) {
          showSignOutDialog(context);
        },
      ),
    ],
  ),
  SettingGroup(
    title: 'Preferencias',
    items: [
      SettingItem(
        icon: Icons.date_range,
        label: 'La semana comienza en',
        onTap: (context) {
          // Navigation or action
        },
      ),
    ],
  ),
];