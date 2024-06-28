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
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _resetTimer(true);  // Initialize the timer and load from storage if necessary
  }

  void _resetTimer(bool loadFromStorage) async {
    final prefs = await SharedPreferences.getInstance();
    if (loadFromStorage) {
      int? savedStart = prefs.getInt('chrono_start');

      if (savedStart != null) {
        _startTime = DateTime.fromMillisecondsSinceEpoch(savedStart);
        _duration = widget.duration - DateTime.now().difference(_startTime!);
        if (_duration.isNegative) {
          _duration = Duration.zero;
          _isPositive = false;
        }
      } else {
        _duration = widget.duration;
        _startTime = DateTime.now();
        await prefs.setInt('chrono_start', _startTime!.millisecondsSinceEpoch);
      }
    } else {
      _duration = widget.duration;
      _startTime = DateTime.now();
      await prefs.setInt('chrono_start', _startTime!.millisecondsSinceEpoch);
    }
    _startTimer();  // Start the timer
  }

  void _startTimer() {
    _timer?.cancel();  // Ensure any existing timer is cancelled before creating a new one
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRunning) {
        setState(() {  // Update the UI with the new duration
          _duration = widget.duration - DateTime.now().difference(_startTime!);
          if (_duration.isNegative) {
            _duration = Duration.zero;
            _isPositive = false;
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomChrono oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _resetTimer(false);  // Reset with the new duration if it changes
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
              strokeCap: StrokeCap.round,
              value: _isPositive ? 1 - _duration.inMilliseconds / widget.duration.inMilliseconds : 1,
              backgroundColor: theme.primaryColorLight,
              valueColor: AlwaysStoppedAnimation<Color>(_isPositive ? theme.primaryColor : theme.primaryColorDark),
            ),
          ),
          Text("$minutes:$seconds", style: theme.textTheme.headlineLarge),
          Positioned(
            bottom: 10,
            child: IconButton(
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              onPressed: () async {
                setState(() {
                  _isRunning = !_isRunning;
                  if (!_isRunning) {
                    _timer?.cancel();  // Stop the timer when paused
                  } else {
                    // Adjust the start time based on the paused duration
                    _startTime = DateTime.now().subtract(widget.duration - _duration);
                    final prefs = SharedPreferences.getInstance();
                    prefs.then((prefs) {
                      prefs.setInt('chrono_start', _startTime!.millisecondsSinceEpoch);
                    });
                    _startTimer();  // Restart the timer
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
