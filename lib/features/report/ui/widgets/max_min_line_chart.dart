// lib/features/report/ui/widgets/max_min_line_chart_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/features/report/provider/report_provider.dart';

class MaxMinLineChart extends ConsumerWidget {
  final bool repsRepresentation;

  const MaxMinLineChart._({this.repsRepresentation = false});

  factory MaxMinLineChart({bool repsRepresentation = false}) {
    return MaxMinLineChart._(repsRepresentation: repsRepresentation);
  }

  int _getDaysInSelectedMonth(int selectedYear, int selectedMonth) {
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }

  Map<DateTime, List<SessionEntity>> _groupSessionsByDate(List<SessionEntity> sessions) {
    final Map<DateTime, List<SessionEntity>> groupedSessions = {};
    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month, session.timeStamp.day);
      groupedSessions.putIfAbsent(date, () => []).add(session);
    }
    return groupedSessions;
  }

  List<FlSpot> _generateSpots(Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    final List<FlSpot> spots = [];
    groupedSessions.forEach((date, sessions) {
      // Compute average weight or average reps.
      final averageValue = sessions
          .map((s) => isMax ? (repsRepresentation ? s.maxReps : s.maxWeight) : (repsRepresentation ? s.minReps : s.minWeight))
          .reduce((a, b) => a + b) / sessions.length;
      spots.add(FlSpot(date.day.toDouble(), averageValue.toDouble()));
    });
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  double _getMinY(Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    if (groupedSessions.isEmpty) return 0;
    if (repsRepresentation) {
      return groupedSessions.values
              .expand((sessions) => sessions)
              .map((s) => isMax ? s.maxReps : s.minReps)
              .reduce((a, b) => a < b ? a : b)
              .toDouble() -
          1;
    }
    return groupedSessions.values
            .expand((sessions) => sessions)
            .map((s) => isMax ? s.maxWeight : s.minWeight)
            .reduce((a, b) => a < b ? a : b)
            .toDouble() -
        1;
  }

  double _getMaxY(Map<DateTime, List<SessionEntity>> groupedSessions, bool isMax) {
    if (groupedSessions.isEmpty) return 10;
    if (repsRepresentation) {
      return groupedSessions.values
              .expand((sessions) => sessions)
              .map((s) => isMax ? s.maxReps : s.minReps)
              .reduce((a, b) => a > b ? a : b)
              .toDouble() +
          1;
    }
    return groupedSessions.values
            .expand((sessions) => sessions)
            .map((s) => isMax ? s.maxWeight : s.minWeight)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reportState = ref.watch(reportProvider);
    final selectedMonth = reportState.selectedMonth;
    final selectedYear = reportState.selectedYear;
    final groupedSessions = _groupSessionsByDate(reportState.filteredSessions);
    final minY = _getMinY(groupedSessions, false);
    final maxY = _getMaxY(groupedSessions, true);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max-Min ${repsRepresentation ? 'Reps' : 'Weights'}",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),
          Container(
            height: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: _getDaysInSelectedMonth(selectedYear, selectedMonth).toDouble(),
                minY: minY,
                maxY: maxY,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 7,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('$day', style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
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
                lineTouchData: const LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
