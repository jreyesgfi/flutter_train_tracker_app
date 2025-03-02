// lib/common/shared_data/selected_exercise_stream_provider.dart
import 'dart:async';

class SelectedExerciseIdSharedStream {
  final _controller = StreamController<String?>.broadcast();
  String? _latest;
  
  /// Expose the stream and update _latest on every event.
  Stream<String?> get stream => _controller.stream.map((value) {
    _latest = value;
    return value;
  });
  
  String? get latestValue => _latest;
  
  void update(String? value) => _controller.add(value);
  void dispose() => _controller.close();
}
