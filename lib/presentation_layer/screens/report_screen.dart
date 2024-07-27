import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ProviderScope is optional here depending on your app structure
    return ProviderScope(
      child: _ReportScreenContent(),
    );
  }
}

class _ReportScreenContent extends ConsumerStatefulWidget {
  @override
  _ReportScreenContentState createState() => _ReportScreenContentState();
}

class _ReportScreenContentState extends ConsumerState<_ReportScreenContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFilterModal() {
    if (_animation.isDismissed) {
      _controller.forward();
    } else if (_animation.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportScreenProvider);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _toggleFilterModal,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Your primary content
          state.allSessions.isNotEmpty
            ? MaxMinLineChart()
            : Center(child: CircularProgressIndicator()),
          // Animated modal
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value * 300 - 300,
                left: 0,
                right: 0,
                child: ReportFilterModal(onClose: _toggleFilterModal),
              );
            },
          ),
        ],
      ),
    );
  }
}