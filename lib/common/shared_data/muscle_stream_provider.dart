// lib/common/shared_data/selected_muscle_stream_provider.dart
import 'dart:async';
import 'package:gymini/domain_layer/entities/core_entities.dart';

class SelectedMuscleSharedStream {
  final _controller = StreamController<MuscleEntity?>.broadcast();
  MuscleEntity? _latest;

  /// Expose the stream (you can add logging here if desired).
  Stream<MuscleEntity?> get stream => _controller.stream;

  /// Synchronous getter for the most recent value.
  MuscleEntity? get latestValue => _latest;
  
  /// Update both _latest and add the value to the stream.
  void update(MuscleEntity? value) {
    _latest = value;
    _controller.add(value);
  }

  void dispose() => _controller.close();
}
