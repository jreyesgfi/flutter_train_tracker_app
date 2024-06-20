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
  bool _isActive = true;

  CustomChronoState() : _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    _loadTimer();
  }

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
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_duration.inSeconds == 0) {
        _isActive = false;
      }
      setState(() {
        _duration -= const Duration(milliseconds: 200);
      });
      if(_duration.inMilliseconds %1000==0){
        _saveEndTime();
      }
    });
  }

  void _saveEndTime() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime endTime = DateTime.now().add(_duration);
    await prefs.setInt('chrono_tick', endTime.millisecondsSinceEpoch);
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
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: _isActive
                  ? 1 - _duration.inMilliseconds / widget.duration.inMilliseconds
                  : 1,
              backgroundColor: _isActive ? theme.primaryColorLight : theme.primaryColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _isActive ? theme.primaryColorDark : theme.primaryColor),
            ),
          ),
          Text("$minutes:$seconds", style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
