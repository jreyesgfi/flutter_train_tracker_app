import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/widgets/common/buttons/custom_button.dart';

class SessionButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final Color? color;
  final int stage;
  final VoidCallback onTap;
  final VoidCallback? onLongPressTakeBack;

  const SessionButton({
    super.key,
    this.label,
    this.icon,
    this.color,
    required this.stage,
    required this.onTap,
    this.onLongPressTakeBack,
  });

  @override
  SessionButtonState createState() => SessionButtonState();
}

class SessionButtonState extends State<SessionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _longPressTriggered = false;
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // When the progress completes, trigger the takeBack callback.
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _longPressTriggered = true;
        widget.onLongPressTakeBack?.call();
        setState(() {
          _showOverlay = false;
        });
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onLongPressTakeBack != null) {
      setState(() {
        _showOverlay = true;
      });
      _progressController.forward(from: 0);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_progressController.isAnimating && !_longPressTriggered) {
      _progressController.stop();
      setState(() {
        _showOverlay = false;
      });
      widget.onTap();
    }
    _resetLongPress();
  }

  void _onTapCancel() {
    _progressController.stop();
    _resetLongPress();
  }

  void _resetLongPress() {
    _progressController.reset();
    setState(() {
      _longPressTriggered = false;
      _showOverlay = false;
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFlat = widget.stage == 0;
    bool isCollapsed = widget.stage < 0 || widget.stage > 1;

    String? effectiveLabel = isCollapsed ? null : widget.label;
    IconData? effectiveIcon = isCollapsed ? null : widget.icon;
    Color effectiveColor = widget.color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomButton(
            onTap: widget.onTap,
            label: effectiveLabel,
            icon: effectiveIcon,
            color: effectiveColor,
            flat: isFlat,
          ),
          // Overlay with an animated circular progress indicator.
          if (_showOverlay)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ProgressCirclePainter(
                      progress: _progressController.value,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;

  _ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill; // Use fill instead of stroke

    // Determine the center and radius.
    final center = Offset(size.width / 2, size.height / 2);
    // Use the full radius so the sector fills the button.
    final radius = size.shortestSide / 2;

    // Start at the top (-90° in radians).
    const startAngle = -1.5708; // -pi/2
    final sweepAngle = progress * 2 * 3.1415926535897932;

    // Draw a filled arc (sector) from the center.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true, // true means the arc is drawn as a sector (pie slice)
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

