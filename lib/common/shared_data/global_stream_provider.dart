// lib/common/shared_data/global_shared_streams_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/shared_data/global_stream.dart';

final globalSharedStreamsProvider = Provider<GlobalSharedStreams>((ref) {
  final globalStreams = GlobalSharedStreams();
  // Dispose the streams when the provider is no longer used.
  ref.onDispose(() => globalStreams.dispose());
  return globalStreams;
});
