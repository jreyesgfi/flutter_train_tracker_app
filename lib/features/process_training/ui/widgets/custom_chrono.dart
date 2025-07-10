import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymini/common/widgets/buttons/circular_hold_button.dart';
import 'package:gymini/common/widgets/buttons/session_button.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';

class SimpleChrono extends StatefulWidget {
  final Duration duration;
  final DateTime startTime;      // initial reference; not used after reset

  const SimpleChrono({
    super.key,
    required this.duration,
    required this.startTime,
  });

  @override
  State<SimpleChrono> createState() => _SimpleChronoState();
}

class _SimpleChronoState extends State<SimpleChrono> {
  late Duration _remaining;
  Timer? _timer;
  bool _isRunning = true;        // toggled by the button

  // ───────────────────────────────────────────────────────────
  // INITIALISE
  // ───────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _remaining = widget.duration - DateTime.now().difference(widget.startTime);
    _startTimer();
  }

  // ───────────────────────────────────────────────────────────
  // TIMER TICK
  // ───────────────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isRunning) return;
      setState(() => _remaining -= const Duration(milliseconds: 100));
    });
  }

  // ───────────────────────────────────────────────────────────
  // BUTTON ACTIONS
  // ───────────────────────────────────────────────────────────
  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();          // restart periodic tick
      } else {
        _timer?.cancel();       // pause
      }
    });
  }

  void _resetChrono() {
    setState(() {
      _timer?.cancel();
      _isRunning = false;       // stay paused after reset
      _remaining = widget.duration;
    });
  }

  // ───────────────────────────────────────────────────────────
  // CLEAN-UP
  // ───────────────────────────────────────────────────────────
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────
  // BUILD
  // ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final exceeded  = _remaining.isNegative;
    final abs       = exceeded ? -_remaining : _remaining;
    String two(int n) => n.toString().padLeft(2, '0');
    final timeText  =
        '${two(abs.inMinutes.remainder(60))}:${two(abs.inSeconds.remainder(60))}';

    final progress = exceeded
        ? 1.0
        : 1 -
            abs.inMilliseconds /
                widget.duration.inMilliseconds.clamp(1, double.infinity);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── 240 px CIRCULAR TIMER ─────────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    strokeCap: StrokeCap.round,
                    value: progress,
                    backgroundColor: AppColors.lightGreyColor,
                    valueColor: AlwaysStoppedAnimation(
                      exceeded ? theme.primaryColor : theme.primaryColorDark,
                    ),
                  ),
                ),
                Text(
                  timeText,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color:
                        exceeded ? theme.primaryColor : theme.primaryColorDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // ─── CONTROL BUTTON ───────────────────────────
            CircularIconButton(
              size:60,
              icon: _isRunning ? Icons.pause : Icons.play_arrow,
              iconColor: theme.primaryColor,
              progressColor: theme.primaryColor.withOpacity(0.3),
              backgroundColor: Colors.transparent,
              onPressed: _toggleRunning,
              onLongPress: _resetChrono,
            ),
          ],
        ),
      ),
    );
  }
}
