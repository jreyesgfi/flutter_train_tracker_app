import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';

class SimpleChrono extends StatefulWidget {
  final Duration duration;
  final DateTime startTime; // Starting time provided externally

  const SimpleChrono({super.key, required this.duration, required this.startTime});

  @override
  SimpleChronoState createState() => SimpleChronoState();
}

class SimpleChronoState extends State<SimpleChrono> {
  late Duration _remaining;
  Timer? _timer;
  final bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    _remaining = widget.duration - DateTime.now().difference(widget.startTime);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRunning) {
        setState(() {
          _calculateRemaining();
        });
      }
    });
  }

  @override
  void didUpdateWidget(SimpleChrono oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration || widget.startTime != oldWidget.startTime) {
      _calculateRemaining();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final exceeded = _remaining.isNegative;
    final duration = exceeded ? -_remaining : _remaining;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  value: exceeded
                      ? 1
                      : 1 - duration.inMilliseconds / widget.duration.inMilliseconds,
                  backgroundColor: AppColors.lightGreyColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    exceeded ? theme.primaryColor : theme.primaryColorDark,
                  ),
                ),
              ),
              Text(
                "$minutes:$seconds",
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: exceeded ? theme.primaryColor : theme.primaryColorDark,
                ),
              ),
            ],
          ),
          // Optionally add control buttons (e.g. pause/play) if needed.
        ],
      ),
    );
  }
}
