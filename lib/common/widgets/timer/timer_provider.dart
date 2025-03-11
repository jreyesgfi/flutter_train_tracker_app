import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, Duration>((ref) {
  return TimerNotifier(duration: const Duration(minutes: 2));
});

class TimerNotifier extends StateNotifier<Duration> {
  final Duration initialDuration;
  Timer? _timer;
  DateTime _startTime;

  TimerNotifier({required Duration duration})
      : initialDuration = duration,
        _startTime = DateTime.now(),
        super(duration) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final newDuration = initialDuration - DateTime.now().difference(_startTime);
      state = newDuration;
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void resume() {
    // Adjust the start time based on paused duration.
    _startTime = DateTime.now().subtract(initialDuration - state);
    _startTimer();
  }

  void reset() {
    _timer?.cancel();
    _startTime = DateTime.now();
    state = initialDuration;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
