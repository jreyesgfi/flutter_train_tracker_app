import 'dart:async';
import 'package:gymini/common/shared_data/global_stream_interface.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';

/// Implementation for a shared selected muscle ID stream.
class SelectedMuscleSharedStream implements SharedStream<MuscleEntity?> {
  final _controller = StreamController<MuscleEntity?>.broadcast();
  MuscleEntity? _latest;

  @override
  Stream<MuscleEntity?> get stream => _controller.stream.map((value) {
    _latest = value;
    return value;
  });

  MuscleEntity? get latestValue => _latest;
  
  @override
  void update(MuscleEntity? value) => _controller.add(value);
  void dispose() => _controller.close();
}
