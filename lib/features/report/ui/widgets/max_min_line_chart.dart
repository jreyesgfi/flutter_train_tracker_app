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

  // ──────────────────────────────────────────────────────────────────────────
  // NEW: derive initial / end date with sensible fall-backs
  // ──────────────────────────────────────────────────────────────────────────
  ({DateTime start, DateTime end}) _getRange() {
    final range = sessionLogState.logFilter.timeRange;
    final now   = DateTime.now();
    final end   = range?.item2 ?? now;                       // note: item2 !
    final start = range?.item1 ?? end.subtract(const Duration(days: 30));
    return (start: start, end: end);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // NEW: convert a calendar date → “days since start”
  // ──────────────────────────────────────────────────────────────────────────
  double _toDayOffset(DateTime date, DateTime start) =>
      date.difference(DateTime(start.year, start.month, start.day)).inDays.toDouble();

  /// Compute relative values (exactly your old algorithm) but use
  /// `_toDayOffset()` for the x-coordinate.
  List<FlSpot> _generateRelativeSpotsByExerciseGrouping(bool isMax, DateTime start) {
    final sessions = sessionLogState.filteredSessions;

    // 1) group by exercise •••
    final Map<String, List<SessionEntity>> groups = {};
    for (final s in sessions) {
      groups.putIfAbsent(s.exerciseId, () => []).add(s);
    }

    final List<MapEntry<DateTime, double>> relativeByDate = [];

    // 2) per group •••
    groups.forEach((_, group) {
      group.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      if (group.isEmpty) return;

      final first = group.first;
      final baseline = isMax
          ? (repsRepresentation ? first.maxReps : first.maxWeight).toDouble()
          : (repsRepresentation ? first.minReps : first.minWeight).toDouble();
      if (baseline == 0) return;

      for (final s in group) {
        final current = isMax
            ? (repsRepresentation ? s.maxReps : s.maxWeight).toDouble()
            : (repsRepresentation ? s.minReps : s.minWeight).toDouble();
        final relPct = ((current - baseline) / baseline) * 100;
        final dateKey = DateTime(s.timeStamp.year, s.timeStamp.month, s.timeStamp.day);
        relativeByDate.add(MapEntry(dateKey, relPct));
      }
    });

    // 3) average per calendar day •••
    final Map<DateTime, List<double>> byDate = {};
    for (final e in relativeByDate) {
      byDate.putIfAbsent(e.key, () => []).add(e.value);
    }

    final List<FlSpot> spots = [];
    byDate.forEach((date, vals) {
      final avg = vals.reduce((a, b) => a + b) / vals.length;
      spots.add(FlSpot(_toDayOffset(date, start), avg));
    });

    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  double _getRelativeMinY(List<FlSpot> s) =>
      s.isEmpty ? 0 : s.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1;

  double _getRelativeMaxY(List<FlSpot> s) =>
      s.isEmpty ? 10 : s.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // ────────────────────────────────────────────────────────────────────────
    // NEW: date window & #days
    // ────────────────────────────────────────────────────────────────────────
    final range = _getRange();
    final totalDays = range.end.difference(range.start).inDays + 1;

    // generate series
    final spotsMin = _generateRelativeSpotsByExerciseGrouping(false, range.start);
    final spotsMax = _generateRelativeSpotsByExerciseGrouping(true,  range.start);
    final minY     = _getRelativeMinY([...spotsMin, ...spotsMax]);
    final maxY     = _getRelativeMaxY([...spotsMin, ...spotsMax]);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max-Min ${repsRepresentation ? 'Reps' : 'Pesos'} (%)",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),
          CustomLegend(
            items: const ["Max", "Min"],
            colors: [theme.primaryColor, theme.primaryColorDark],
          ),
          const SizedBox(height: 4),

          // ──────────────────────────────────────────────────────────────────
          // chart
          // ──────────────────────────────────────────────────────────────────
          Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: LineChart(
              LineChartData(
                minX: 0,                           // start == day 0
                maxX: (totalDays - 1).toDouble(),  // inclusive end
                minY: minY,
                maxY: maxY,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (v, _) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text("${v.toStringAsFixed(1)}%",
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 7,                 // one tick per week
                      reservedSize: 40,
                      getTitlesWidget: (v, _) {
                        final date = range.start.add(Duration(days: v.toInt()));
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "${date.day}/${date.month}",  // e.g. 05/07
                              style: const TextStyle(fontSize: 12),
                            ),
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

                // 2 series
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsMin,
                    isCurved: true,
                    dashArray: [3, 6],
                    color: theme.primaryColorDark,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: spotsMax,
                    isCurved: true,
                    color: theme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],

                // tool-tip
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touched) => touched.map((barSpot) {
                      final label = barSpot.barIndex == 0 ? "Min" : "Max";
                      return LineTooltipItem(
                        "$label: ${barSpot.y.toStringAsFixed(1)}%",
                        const TextStyle(fontSize: 12, color: Colors.white),
                      );
                    }).toList(),
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
