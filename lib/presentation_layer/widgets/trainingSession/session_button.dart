import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/custom_button.dart';

class SessionButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? color;
  final int stage;
  final VoidCallback onTap;

  const SessionButton({
    super.key,
    this.label,
    this.icon,
    this.color,
    required this.stage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    

    bool isOutlined = stage > 0;
    bool isCollapsed = stage < 0;

    // Determine the properties based on the stage
    String? effectiveLabel = isCollapsed ? null : label;
    IconData? effectiveIcon = isCollapsed ? null : icon;
    Color effectiveColor = color ?? Theme.of(context).primaryColor;  // Use default color if not provided

    return CustomButton(
      onTap: onTap,
      label: effectiveLabel,
      icon: effectiveIcon,
      color: effectiveColor,
      outlined: isOutlined,
    );
  }
}
