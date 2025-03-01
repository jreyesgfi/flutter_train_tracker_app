import 'dart:async';

import 'package:gymini/common/shared_data/session_stream_provider.dart';
import 'package:gymini/common/shared_data/global_stream_interface.dart';

/// Implementation for a shared selected muscle ID stream.
class SelectedMuscleIdSharedStream implements SharedStream<String?> {
  final _controller = StreamController<String?>.broadcast();
  @override
  Stream<String?> get stream => _controller.stream;
  @override
  void update(String? value) => _controller.add(value);
  void dispose() => _controller.close();
}