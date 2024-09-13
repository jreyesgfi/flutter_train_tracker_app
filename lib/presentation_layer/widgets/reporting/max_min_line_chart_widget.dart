import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaxMinLineChart extends ConsumerWidget {
  final bool repsRepresentation;

  MaxMinLineChart._({
    this.repsRepresentation = false,
  });

  factory MaxMinLineChart({bool repsRepresentation = false}) {
    return MaxMinLineChart._(repsRepresentation: repsRepresentation);
  }

  int _getDaysInSelectedMonth(int selectedYear, int selectedMonth) {
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }

  Map<DateTime, List<SessionEntity>> _groupSessionsByDate(
    List<SessionEntity> sessions,
  ) {
    final Map<DateTime, List<SessionEntity>> groupedSessions = {};
    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month,
          session.timeStamp.day);

      if (groupedSessions[date] == null) {
        groupedSessions[date] = [];
      }
      groupedSessions[date]!.add(session);
    }
    return groupedSessions;
  }

  List<FlSpot> _generateSpots(
      Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    final List<FlSpot> spots = [];
    groupedSessions.forEach((date, sessions) {
      final averageWeight = sessions
              .map((s) => isMax ? s.maxWeight : s.minWeight)
              .reduce((a, b) => a + b) /
          sessions.length;
      final averageReps = sessions
              .map((s) => isMax ? s.maxReps : s.minReps)
              .reduce((a, b) => a + b) /
          sessions.length;
      spots.add(FlSpot(date.day.toDouble(),
          repsRepresentation ? averageReps : averageWeight));
    });
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  double _getMinX() {
    return 1;
  }

  double _getMinY(
      Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    if (groupedSessions.isEmpty) return 0;
    // Reps Representation
    if (repsRepresentation == true) {
      return groupedSessions.values
              .expand((sessions) => sessions)
              .map((s) => isMax ? s.maxReps : s.minReps)
              .reduce((a, b) => a < b ? a : b) -
          1;
    }
    // Weight Representation
    return groupedSessions.values
            .expand((sessions) => sessions)
            .map((s) => isMax ? s.maxWeight : s.minWeight)
            .reduce((a, b) => a < b ? a : b) -
        1;
  }

  double _getMaxY(
      Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    if (groupedSessions.isEmpty) return 10; // Default maximum value
    // Reps Representation
    if (repsRepresentation == true) {
      return groupedSessions.values
              .expand((sessions) => sessions)
              .map((s) => isMax ? s.maxReps : s.minReps)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
    // Weight Representation
    return groupedSessions.values
            .expand((sessions) => sessions)
            .map((s) => isMax ? s.maxWeight : s.minWeight)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(reportScreenProvider);
    final selectedMonth = provider.selectedMonth;
    final selectedYear = provider.selectedYear;
    final groupedSessions = _groupSessionsByDate(provider.filteredSessions);

    final minY = _getMinY(groupedSessions, false);
    final maxY = _getMaxY(groupedSessions, true);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit*2),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start
        children: [
          Text(
            "Max-Min ${repsRepresentation ? "Reps" : "Weights"}",
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.primaryColorDark),
          ),
          SizedBox(height: 12), // Space between the title and chart
          Container(
            height: 300,
            padding: const EdgeInsets.all(20.0), // Padding inside the Container
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: LineChart(
              LineChartData(
                minX: _getMinX(),
                maxX: _getDaysInSelectedMonth(selectedYear, selectedMonth)
                    .toDouble(),
                minY: minY,
                maxY: maxY,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize:
                          55, // Increase reserved size for the left titles
                      getTitlesWidget: (value, meta) {
                        return Align(
                          alignment:
                              Alignment.centerLeft, // Align titles to the right
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    8.0), // Add padding to move titles further from the axis
                            child: Text('${value.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 7,
                      reservedSize:
                          40, // Increase reserved size for the bottom titles
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Align(
                          alignment: Alignment
                              .bottomCenter, // Align titles to the bottom
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top:
                                    8.0), // Add padding to move titles further from the axis
                            child: Text('$day', style: TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(groupedSessions, false),
                    isCurved: true,
                    color: theme.primaryColorDark,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: _generateSpots(groupedSessions, true),
                    isCurved: true,
                    color: theme.primaryColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: false, // Border around the plot area
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: Colors.transparent,
                      ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
