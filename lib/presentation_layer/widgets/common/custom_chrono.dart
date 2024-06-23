import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomChrono extends StatefulWidget {
  final Duration duration;

  const CustomChrono({Key? key, required this.duration}) : super(key: key);

  @override
  CustomChronoState createState() => CustomChronoState();
}

class CustomChronoState extends State<CustomChrono> {
  late Duration _duration;
  Timer? _timer;
  bool _isPositive = true;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _resetTimer(false);
  }

  void _resetTimer(bool loadFromStorage) async {
    if (loadFromStorage) {
      final prefs = await SharedPreferences.getInstance();
      int? savedTick = prefs.getInt('chrono_tick');
      DateTime? endTime = savedTick != null ? DateTime.fromMillisecondsSinceEpoch(savedTick) : null;

      if (endTime != null && DateTime.now().isBefore(endTime)) {
        _duration = endTime.difference(DateTime.now());
      } else {
        _duration = widget.duration;
      }
    } else {
      _duration = widget.duration;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Ensure any existing timer is cancelled before creating a new one
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_duration.inSeconds <= 0) {
        _timer?.cancel();
        _isPositive = false;
      }

      if (_isRunning) {
        setState(() {
          _duration -= const Duration(milliseconds: 100);
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomChrono oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _resetTimer(false); // Reset with the new duration if it changes
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
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              value: _isPositive ? 1 - _duration.inMilliseconds / widget.duration.inMilliseconds : 1,
              backgroundColor: theme.primaryColorLight,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColorDark),
            ),
          ),
          Text("$minutes:$seconds", style: theme.textTheme.headlineLarge),
          Positioned(
            bottom: 10,
            child: IconButton(
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _isRunning = !_isRunning;
                  if (!_isRunning) {
                    _timer?.cancel();
                  } else {
                    _startTimer();
                  }
                });
              },
              color: theme.primaryColor,
              iconSize: 40,
            ),
          )
        ],
      ),
    );
  }
}
