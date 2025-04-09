// lib/common/shared_data/selected_filter_stream_provider.dart
import 'dart:async';
import 'package:gymini/domain_layer/entities/log_filter.dart';

class LogFilterSharedStream {
  final _controller = StreamController<LogFilter?>.broadcast();
  LogFilter? _latest;

  /// Expose the stream with optional logging
  Stream<LogFilter?> get stream => _controller.stream;

  /// Synchronous getter for the most recent filter value.
  LogFilter? get latestValue => _latest;
  
  /// Update the filter state and notify all subscribers.
  void update(LogFilter? filter) {
    _latest = filter;
    _controller.add(filter);
  }

  void dispose() => _controller.close();
}
