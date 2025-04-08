import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.size = 50, // Default size
  });

  @override
  CustomIconButtonState createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((value) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(customTheme?.properties.borderRadius ?? 0.0),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: widget.size*0.7, // Icon size proportional to the button
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
