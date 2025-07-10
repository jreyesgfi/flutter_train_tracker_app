import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Circular button with optional hold-to-confirm radial fill.
///
/// • Tap → `onPressed`  
/// • Hold for `longPressDuration` → pie-fill + `onLongPress`
class CircularIconButton extends StatefulWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.progressColor = const Color.fromARGB(77, 233, 21, 21), // 30 % white
    this.size = 56,
    this.longPressDuration = const Duration(seconds: 1),
  });

  // visuals
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color progressColor;
  final double size;                       // diameter

  // behaviour
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Duration longPressDuration;

  @override
  State<CircularIconButton> createState() => _CircularIconButtonState();
}

class _CircularIconButtonState extends State<CircularIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _showOverlay = false;
  bool _longPressTriggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.longPressDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _longPressTriggered = true;
          widget.onLongPress?.call();
          setState(() => _showOverlay = false);
        }
      });
  }

  // ─────────── gesture helpers ───────────
  void _handleTapDown(TapDownDetails _) {
    if (widget.onLongPress == null) return;
    setState(() => _showOverlay = true);
    _ctrl.forward(from: 0);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_ctrl.isAnimating && !_longPressTriggered) {
      _ctrl.stop();
      setState(() => _showOverlay = false);
      widget.onPressed();
    }
    _reset();
  }

  void _handleTapCancel() {
    _ctrl.stop();
    _reset();
  }

  void _reset() {
    _ctrl.reset();
    _longPressTriggered = false;
    setState(() => _showOverlay = false);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ────────────────────── build ──────────────────────
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // button face
          GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.backgroundColor,
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: widget.size * 0.5,
              ),
            ),
          ),

          // radial progress overlay
          if (_showOverlay)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => CustomPaint(
                  painter: _ProgressCirclePainter(
                    progress: _ctrl.value,
                    color: widget.progressColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ───────────────────────── painter ─────────────────────────
class _ProgressCirclePainter extends CustomPainter {
  const _ProgressCirclePainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    const startAngle = -math.pi / 2;            // 12 o’clock
    final sweepAngle = progress * 2 * math.pi;  // 0 → 360°

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressCirclePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color;
}
