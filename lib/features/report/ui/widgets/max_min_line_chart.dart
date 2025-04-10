// lib/features/report/ui/widgets/max_min_line_chart_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymini/common/widgets/reporting/custom_legend.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';

class MaxMinLineChart extends ConsumerWidget {
  final bool repsRepresentation;
  final SessionLogProviderState sessionLogState;

  const MaxMinLineChart({
    super.key,
    required this.sessionLogState,
    this.repsRepresentation = false,
  });

  /// Returns the number of days in the given month.
  int _getDaysInSelectedMonth(int selectedYear, int selectedMonth) {
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }

  /// Compute relative percentage changes for each session based on the first session’s value
  /// in each exercise group.
  ///
  /// The steps are:
  ///   1. Group sessions by exerciseId.
  ///   2. For each group, sort sessions by date.
  ///   3. For each session, compute the relative percentage difference from the group baseline.
  ///   4. Group these relative values by date.
  ///   5. For each date, compute the mean of the relative values.
  ///
  /// [isMax] indicates whether to use the max value (otherwise, min is used).
  List<FlSpot> _generateRelativeSpotsByExerciseGrouping(bool isMax) {
    final sessions = sessionLogState.filteredSessions;
    // Group sessions by exerciseId.
    final Map<String, List<SessionEntity>> groups = {};
    for (final session in sessions) {
      groups.putIfAbsent(session.exerciseId, () => []).add(session);
    }
    // List to hold (date, relativePercentage) entries.
    List<MapEntry<DateTime, double>> allRelativeValues = [];

    // Iterate through each exercise group.
    groups.forEach((exerciseId, group) {
      // Sort sessions by date.
      group.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      if (group.isEmpty) return;
      // Get baseline from the first session of the group.
      final firstSession = group.first;
      double baseline;
      if (isMax) {
        baseline = repsRepresentation
            ? firstSession.maxReps.toDouble()
            : firstSession.maxWeight.toDouble();
      } else {
        baseline = repsRepresentation
            ? firstSession.minReps.toDouble()
            : firstSession.minWeight.toDouble();
      }
      // If baseline is 0, skip the group (avoid division by 0).
      if (baseline == 0) return;
      // For each session in the group, compute the relative percentage change.
      for (final session in group) {
        double currentValue;
        if (isMax) {
          currentValue = repsRepresentation
              ? session.maxReps.toDouble()
              : session.maxWeight.toDouble();
        } else {
          currentValue = repsRepresentation
              ? session.minReps.toDouble()
              : session.minWeight.toDouble();
        }
        double relativeChange = ((currentValue - baseline) / baseline) * 100;
        // Use only the date part of the timestamp.
        final dateKey = DateTime(session.timeStamp.year,
            session.timeStamp.month, session.timeStamp.day);
        allRelativeValues.add(MapEntry(dateKey, relativeChange));
      }
    });

    // Now group the relative values by date.
    final Map<DateTime, List<double>> groupedByDate = {};
    for (final entry in allRelativeValues) {
      groupedByDate.putIfAbsent(entry.key, () => []).add(entry.value);
    }

    // Compute the average relative change for each date.
    List<FlSpot> spots = [];
    groupedByDate.forEach((date, values) {
      final average = values.reduce((a, b) => a + b) / values.length;
      spots.add(FlSpot(date.day.toDouble(), average));
    });
    // Sort by day.
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  /// Compute an adjusted minimum Y value for the chart (adds a bit of padding).
  double _getRelativeMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    return minY - 1;
  }

  /// Compute an adjusted maximum Y value for the chart (adds a bit of padding).
  double _getRelativeMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 10;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxY + 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedMonth = sessionLogState.selectedMonth;
    final selectedYear = sessionLogState.selectedYear;
    final daysInMonth = _getDaysInSelectedMonth(selectedYear, selectedMonth);

    // Generate spots for both the min and max series.
    final relativeSpotsMin = _generateRelativeSpotsByExerciseGrouping(false);
    final relativeSpotsMax = _generateRelativeSpotsByExerciseGrouping(true);
    final allSpots = [...relativeSpotsMin, ...relativeSpotsMax];
    final minY = _getRelativeMinY(allSpots);
    final maxY = _getRelativeMaxY(allSpots);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max-Min ${repsRepresentation ? 'Reps' : 'Pesos'} (%)",
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),

          CustomLegend(
            items:const ["Max", "Min"],
            colors:[theme.primaryColor, theme.primaryColorDark]
          ),
          const SizedBox(height: 4),
          
          Container(
            height: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: daysInMonth.toDouble(),
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
                            child: Text("${value.toStringAsFixed(1)}%",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Set the interval to 7 days
                      interval: 7,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '$day',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                // Lines
                lineBarsData: [
                  LineChartBarData(
                    spots: relativeSpotsMin,
                    isCurved: true,
                    dashArray: [3, 6],
                    color: theme.primaryColorDark,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: relativeSpotsMax,
                    isCurved: true,
                    color: theme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                // Tooltip
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        // Determine label based on line index.
                        final label = barSpot.barIndex == 0 ? "Min" : "Max";
                        return LineTooltipItem(
                          "$label: ${barSpot.y.toStringAsFixed(1)}%",
                          const TextStyle(fontSize: 12, color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
