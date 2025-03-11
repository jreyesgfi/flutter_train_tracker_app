import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomChrono extends StatefulWidget {
  final Duration duration;
  final int stage; // Pass the stage as a parameter

  const CustomChrono({super.key, required this.duration, required this.stage});

  @override
  CustomChronoState createState() => CustomChronoState();
}

class CustomChronoState extends State<CustomChrono> {
  late Duration _duration;
  Timer? _timer;
  bool _isRunning = true;
  DateTime? _startTime;
  bool _isInitialized = false;

  // Use a unique key for each stage
  String get _prefsKey => 'chrono_start_${widget.stage}';

  @override
  void initState() {
    super.initState();
    _resetTimer(loadFromStorage: true);
  }

  void _resetTimer({required bool loadFromStorage}) async {
    final prefs = await SharedPreferences.getInstance();

    if (loadFromStorage) {
      int? savedStart = prefs.getInt(_prefsKey);
      if (savedStart != null) {
        _startTime = DateTime.fromMillisecondsSinceEpoch(savedStart);
        _duration = widget.duration - DateTime.now().difference(_startTime!);
      } else {
        _duration = widget.duration;
        _startTime = DateTime.now();
        await prefs.setInt(_prefsKey, _startTime!.millisecondsSinceEpoch);
      }
    } else {
      // Always reset if loadFromStorage is false
      _duration = widget.duration;
      _startTime = DateTime.now();
      await prefs.setInt(_prefsKey, _startTime!.millisecondsSinceEpoch);
    }
    setState(() {
      _isInitialized = true;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRunning) {
        setState(() {
          _duration = widget.duration - DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomChrono oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If either the duration or stage changes, reset the timer.
    if (widget.duration != oldWidget.duration || widget.stage != oldWidget.stage) {
      _resetTimer(loadFromStorage: false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final exceeded = _duration.isNegative;
    final duration = exceeded ? -_duration : _duration;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      exceeded ? theme.primaryColor : theme.primaryColorDark),
                ),
              ),
              Text(
                "$minutes:$seconds",
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: _duration.isNegative ? theme.primaryColor : theme.primaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 250,
                height: 6,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: AppColors.lightGreyColor,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                )),
              ),
              SizedBox(
                height: 62,
                child: IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: () async {
                    setState(() {
                      _isRunning = !_isRunning;
                      if (!_isRunning) {
                        _timer?.cancel();
                      } else {
                        _startTime = DateTime.now().subtract(widget.duration - _duration);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setInt(_prefsKey, _startTime!.millisecondsSinceEpoch);
                        });
                        _startTimer();
                      }
                    });
                  },
                  color: theme.primaryColor,
                  iconSize: 40,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
