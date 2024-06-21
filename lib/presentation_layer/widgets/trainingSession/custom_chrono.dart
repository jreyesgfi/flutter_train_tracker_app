import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomChrono extends StatefulWidget {
  final Duration duration;

  const CustomChrono({super.key, required this.duration});

  @override
  CustomChronoState createState() => CustomChronoState();
}

class CustomChronoState extends State<CustomChrono> {
  Duration _duration;
  late Timer _timer;
  bool _isPositive = true;
  bool _isRunning = true;

  CustomChronoState() : _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    _loadTimer();
  }

  // persist the time
  void _loadTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedTick = prefs.getInt('chrono_tick');
    DateTime? endTime = savedTick != null
        ? DateTime.fromMillisecondsSinceEpoch(savedTick)
        : null;

    if (endTime != null && DateTime.now().isBefore(endTime)) {
      _duration = endTime.difference(DateTime.now());
    } else {
      _duration = widget.duration;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_duration.inSeconds == 0) {
        _isPositive = false;
      }

      if (_isRunning) {
        setState(() {
          _duration -= const Duration(milliseconds: 100);
        });
        if (_duration.inMilliseconds % 1000 == 0) {
          _saveEndTime();
        }
      }
    });
  }

  void _saveEndTime() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime endTime = DateTime.now().add(_duration);
    await prefs.setInt('chrono_tick', endTime.millisecondsSinceEpoch);
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning && !_timer.isActive) {
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
              strokeCap: StrokeCap.round,
              value: _isPositive
                  ? 1 -
                      _duration.inMilliseconds / widget.duration.inMilliseconds
                  : 1,
              backgroundColor:
                  _isPositive ? theme.primaryColorLight : theme.primaryColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _isPositive ? theme.primaryColorDark : theme.primaryColor),
            ),
          ),
          Text("$minutes:$seconds", style: theme.textTheme.headlineLarge),
          Positioned(
            bottom: 10,
            child: IconButton(
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              onPressed: _toggleTimer,
              color: theme.primaryColor,
              iconSize: 40,
            ),
          )
        ],
      ),
    );
  }
}
