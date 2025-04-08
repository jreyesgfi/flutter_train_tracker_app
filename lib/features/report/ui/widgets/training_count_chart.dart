// lib/features/report/ui/widgets/training_count_bar_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common_layer/utils/date_labels.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/features/report/provider/report_provider.dart';

class TrainingCountBarChart extends ConsumerWidget {
  final bool countMusclesTrained; // Count muscles versus sessions

  const TrainingCountBarChart._({this.countMusclesTrained = false});

  factory TrainingCountBarChart({bool countMusclesTrained = false}) {
    return TrainingCountBarChart._(countMusclesTrained: countMusclesTrained);
  }

  /// Groups sessions by day of week. If [countMusclesTrained] is true,
  /// the count for each day is the unique number of muscles trained.
  Map<int, int> _groupSessionsByDayOfWeek(List<SessionEntity> sessions) {
    // Map dates to unique sets of muscleIds
    final Map<DateTime, Set<String>> dateMuscleMap = {};
    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month, session.timeStamp.day);
      dateMuscleMap.putIfAbsent(date, () => {}).add(session.muscleId);
    }
    // Aggregate counts by day of week (1=Monday, 7=Sunday)
    final Map<int, int> dayOfWeekCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    for (var entry in dateMuscleMap.entries) {
      int dayOfWeek = entry.key.weekday;
      int count = countMusclesTrained ? entry.value.length : 1;
      dayOfWeekCounts[dayOfWeek] = (dayOfWeekCounts[dayOfWeek] ?? 0) + count;
    }
    return dayOfWeekCounts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reportState = ref.watch(reportProvider);
    // Depending on the flag, choose filtered sessions by date or overall filtered sessions.
    final List<SessionEntity> sessions = countMusclesTrained 
        ? reportState.filteredSessionsByDate 
        : reportState.filteredSessions;

    final groupedSessions = _groupSessionsByDayOfWeek(sessions);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${countMusclesTrained ? 'Muscles Trained' : 'Sessions'} by Day of Week",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: countMusclesTrained ? 2 : 1,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final dayOfWeek = value.toInt();
                        final dayName = numToWeekDayName[dayOfWeek] ?? '';
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(dayName, style: const TextStyle(fontSize: 12)),
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
                barGroups: groupedSessions.entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: theme.primaryColorDark,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
