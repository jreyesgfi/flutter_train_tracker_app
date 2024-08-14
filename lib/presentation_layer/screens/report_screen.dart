import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/count_bar_chart.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_modal.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

  Widget _buildCharts() {
    final state = ref.watch(reportScreenProvider);
    if (state.allSessions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    
    return ListView(
      children: [
        TrainingCountBarChart(),
        TrainingCountBarChart(countMusclesTrained: true),
        MaxMinLineChart(),
        MaxMinLineChart(repsRepresentation: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFilterModal,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Filter section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ReportFilterSection(), // Add the filter section here
          ),

          // Primary content
          Positioned(
            top: 55, // Adjust based on the height of your filter section
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCharts(),
          ),
          
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