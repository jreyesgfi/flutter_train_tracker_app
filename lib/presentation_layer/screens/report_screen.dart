import 'package:flutter/material.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/infrastructure_layer/repository_impl/mock_data_repository.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/max_min_line_chart_widget.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/reporting/report_filter_modal.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  bool _showFilterModal = false;
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
    setState(() {
      _showFilterModal = !_showFilterModal;
      if (_showFilterModal) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _loadInitialData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var allMuscles = snapshot.data![0] as List<MuscleData>;
          var allExercises = snapshot.data![1] as List<ExerciseData>;

          return ChangeNotifierProvider<ReportScreenProvider>(
            create: (_) => ReportScreenProvider(allMuscles, allExercises),
            child: Consumer<ReportScreenProvider>(
              builder: (context, provider, child) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.filter_list),
                            onPressed: _toggleFilterModal,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: provider.filteredSessions.isEmpty
                                ? Center(child: Text('No data available'))
                                : MaxMinLineChart(),
                          ),
                        ),
                      ],
                    ),
                    if (_showFilterModal) ...[
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top: -300 + (_animation.value * 300),
                            left: 0,
                            right: 0,
                            child: Material(
                              elevation: 8,
                              color: Colors.white,
                              child: ReportFilterModal(onClose: _toggleFilterModal),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<dynamic>> _loadInitialData() async {
    var repo = MockDataRepository();
    List<MuscleData> allMuscles = await repo.fetchAllMuscles();
    List<ExerciseData> allExercises = await repo.fetchAllExercises();
    return [allMuscles, allExercises];
  }
}
