import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData? icon; // Icon is now optional
  final String? label; // Optional label
  final Color? color; // General color for background or stroke, can be null
  final double size; // Overall size of the button
  final bool outlined; // Whether the button is outlined
  final bool flat;


  const CustomButton({
    super.key,
    required this.onTap,
    this.icon,
    this.label,
    this.color,
    this.size = 40, // Default size
    this.outlined = false,
    this.flat = false,
  });
  // : assert(icon != null || label != null, 'An icon or label must be provided.');

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
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

    double borderRadius = widget.size / 2; // Ensures the button can become a perfect circle
    // outlined and compact
    final collided = (widget.icon == null && widget.label == null);
    Color effectiveColor = widget.color ?? Theme.of(context).scaffoldBackgroundColor;
    effectiveColor = collided ? effectiveColor.withOpacity(0.15) : effectiveColor;
    //Color backgroundColor = widget.outlined ? theme.primaryColorLight : effectiveColor;
    //Color backgroundColor = (widget.icon == null && widget.label == null) ? effectiveColor.withOpacity(0.1) : effectiveColor;


    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.label != null ? 200 : widget.size, // Wider if label is present
              height: widget.size,
              decoration: BoxDecoration(
                color: 
                  widget.outlined || widget.flat ? Colors.transparent : 
                  effectiveColor,
                border: widget.outlined ? Border.all(color: effectiveColor, width: 2) : null,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              alignment: Alignment.center,
              child: widget.label != null
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.label!,
                      style: 
                      widget.flat ? 
                        theme.textTheme.titleMedium?.copyWith(color:theme.primaryColorDark, fontWeight: FontWeight.bold)
                        : theme.textTheme.titleSmall?.copyWith(color:widget.outlined ? effectiveColor : Colors.white),                    
                    )
                  )
                  : (widget.icon != null
                      ? Icon(
                          widget.icon,
                          color: widget.outlined ? effectiveColor : Colors.white,
                          size: widget.size * 0.6, // Icon size proportional to the button
                        )
                      : SizedBox.shrink()), // No icon or label means nothing to show
            ),
          ),
        ),
      ),
    );
  }
}
