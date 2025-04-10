// lib/features/report/ui/widgets/training_count_bar_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymini/common/widgets/reporting/custom_legend.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common_layer/utils/date_labels.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/log_provider_state.dart';

class TrainingCountBarChart extends ConsumerWidget {
  final SessionLogGrainedProviderState sessionLogState;

  const TrainingCountBarChart({
    super.key,
    required this.sessionLogState
  });




  Map<int, Map<String, int>> _groupTrainingsByDayOfWeekCombined(List<SessionEntity> sessions) {
    // Group sessions by the date (ignoring time).
    final Map<DateTime, List<SessionEntity>> sessionsByDate = {};
    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month, session.timeStamp.day);
      sessionsByDate.putIfAbsent(date, () => []).add(session);
    }

    // Initialize a map from weekday (1 = Monday, ... 7 = Sunday)
    // with keys 'trainings' and 'muscles', both starting at 0.
    final Map<int, Map<String, int>> dayOfWeekData = {
      1: {'trainings': 0, 'muscles': 0},
      2: {'trainings': 0, 'muscles': 0},
      3: {'trainings': 0, 'muscles': 0},
      4: {'trainings': 0, 'muscles': 0},
      5: {'trainings': 0, 'muscles': 0},
      6: {'trainings': 0, 'muscles': 0},
      7: {'trainings': 0, 'muscles': 0},
    };

    // For each unique date, increment the training count by 1
    // and add the distinct muscle count for that date.
    sessionsByDate.forEach((date, sessionsList) {
      final int day = date.weekday;
      // Since each date counts as only one training, increment by 1.
      dayOfWeekData[day]!['trainings'] = dayOfWeekData[day]!['trainings']! + 1;
      // Count how many unique muscles were trained that day.
      final int uniqueMuscles = sessionsList.map((s) => s.muscleId).toSet().length;
      dayOfWeekData[day]!['muscles'] = dayOfWeekData[day]!['muscles']! + uniqueMuscles;
    });

    return dayOfWeekData;
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Depending on the flag, choose filtered sessions by date or overall filtered sessions.
    final List<SessionEntity> sessions = sessionLogState.filteredSessions;

    final groupedData = _groupTrainingsByDayOfWeekCombined(sessions);
    final barGroups = groupedData.entries.map((entry) {
      final day = entry.key;
      final sessionsCount = entry.value['trainings']!.toDouble();
      final musclesCount = entry.value['muscles']!.toDouble();
      return BarChartGroupData(
        x: day,
        barRods: [
          // First bar: sessions count using the main gimini color.
          BarChartRodData(
            toY: sessionsCount,
            color: theme.primaryColor,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          // Second bar: muscles count using the secondary color.
          BarChartRodData(
            toY: musclesCount,
            color: theme.primaryColorDark,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        barsSpace: 4, // Space between the two bars in the same group.
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Conteo Entrenamientos",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),
          CustomLegend(
            items:const ["Entrenamientos", "Músculos"],
            colors:[theme.primaryColor, theme.primaryColorDark]
          ),
          const SizedBox(height: 4),
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
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
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
                barGroups: barGroups,

                // Tooltip
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? "Entrenamientos: " : "Músculos: ";
                      return BarTooltipItem(
                        label + rod.toY.toStringAsFixed(0),
                        const TextStyle(fontSize: 12, color: Colors.white),
                      );
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
