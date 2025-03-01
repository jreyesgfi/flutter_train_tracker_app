// lib/common/shared_data/global_shared_streams.dart

import 'dart:async';
import 'package:gymini/common/shared_data/global_stream_interface.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';

/// Implementation for a shared session stream.
class SessionSharedStream implements SharedStream<SessionEntity?> {
  final _controller = StreamController<SessionEntity?>.broadcast();
  @override
  Stream<SessionEntity?> get stream => _controller.stream;
  @override
  void update(SessionEntity? value) => _controller.add(value);
  void dispose() => _controller.close();
}


