import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/custom_icon_button.dart';

class StopIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const StopIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: onTap,
      icon: Icons.stop,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}