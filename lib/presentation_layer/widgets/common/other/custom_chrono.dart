import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
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
  bool _isRunning = true;
  DateTime? _startTime;
  bool _isInitialized = false; // New flag to track initialization

  @override
  void initState() {
    super.initState();
    _resetTimer(false);
  }

  void _resetTimer(bool loadFromStorage) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear saved start time for new key
    await prefs.remove('chrono_start');

    if (loadFromStorage) {
      int? savedStart = prefs.getInt('chrono_start');

      if (savedStart != null) {
        _startTime = DateTime.fromMillisecondsSinceEpoch(savedStart);
        _duration = widget.duration - DateTime.now().difference(_startTime!);
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
    setState(() {
      _isInitialized = true; // Set the flag to true after initialization
    });
    _startTimer();
  }

  void _startTimer() {
    _timer
        ?.cancel(); // Ensure any existing timer is cancelled before creating a new one
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRunning) {
        setState(() {
          // Update the UI with the new duration
          _duration = widget.duration - DateTime.now().difference(_startTime!);
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
    if (!_isInitialized) {
      return SizedBox.shrink(); // Return an empty widget while initializing
    }

    final theme = Theme.of(context);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final exceded = _duration.isNegative;
    final duration = exceded
        ? -_duration
        : _duration; // Calculate the absolute value of the duration
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    

    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center,
        children: [
          SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            value: exceded? 1: 1 - duration.inMilliseconds / widget.duration.inMilliseconds,
            backgroundColor: AppColors.lightGreyColor,
            valueColor: AlwaysStoppedAnimation<Color>(exceded? theme.primaryColor: theme.primaryColorDark),
          ),
        ),
        Text(
          "$minutes:$seconds",
          // "${_duration.isNegative ? "-" : ""}$minutes:$seconds",
          style: theme.textTheme.headlineLarge!.copyWith(
            color: _duration.isNegative
                ? theme.primaryColor
                : theme.primaryColorDark,
          ),
        ),
        ],),
        SizedBox(height:32),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250,
              height: 6,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: AppColors.lightGreyColor,
                  style: BorderStyle.solid,
                  width: 2,
                  ))
              ),
            ),
            SizedBox(
          height: 62,
          child: IconButton(
            icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              setState(() {
                _isRunning = !_isRunning;
                if (!_isRunning) {
                  _timer?.cancel(); // Stop the timer when paused
                } else {
                  // Adjust the start time based on the paused duration
                  _startTime =
                      DateTime.now().subtract(widget.duration - _duration);
                  final prefs = SharedPreferences.getInstance();
                  prefs.then((prefs) {
                    prefs.setInt(
                        'chrono_start', _startTime!.millisecondsSinceEpoch);
                  });
                  _startTimer(); // Restart the timer
                }
              });
            },
            color: theme.primaryColor,
            iconSize: 40,
          ),
        )],)
      ],
    );
  }
}
