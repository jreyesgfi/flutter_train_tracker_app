// lib/common/shared_data/selected_exercise_stream_provider.dart
import 'dart:async';
import 'package:gymini/domain_layer/entities/core_entities.dart';

class SelectedExerciseSharedStream {
  final _controller = StreamController<ExerciseEntity?>.broadcast();
  ExerciseEntity? _latest;

  Stream<ExerciseEntity?> get stream => _controller.stream;
  ExerciseEntity? get latestValue => _latest;
  
  void update(ExerciseEntity? value) {
    _latest = value;
    _controller.add(value);
  }
  
  void dispose() => _controller.close();
}
