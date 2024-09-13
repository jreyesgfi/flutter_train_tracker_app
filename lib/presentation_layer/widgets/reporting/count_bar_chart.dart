import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/common_layer/utils/date_labels.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingCountBarChart extends ConsumerWidget {
  final bool countMusclesTrained; // Flag to count number of muscles trained vs. sessions
  var selectedMonth = DateTime.now().month;
  var selectedYear = DateTime.now().year;

  TrainingCountBarChart._({
    this.countMusclesTrained = false,
  });

  factory TrainingCountBarChart({bool countMusclesTrained = false}) {
    return TrainingCountBarChart._(countMusclesTrained: countMusclesTrained);
  }

  DateTime _getSelectedMonthDateTime() {
    return DateTime(selectedYear, selectedMonth);
  }

  Map<int, int> _groupSessionsByDayOfWeek(List<SessionEntity> sessions) {
    // Step 1: Group sessions by date and muscleId
    final Map<DateTime, Set<String>> dateMuscleMap = {};

    for (var session in sessions) {
      final date = DateTime(session.timeStamp.year, session.timeStamp.month, session.timeStamp.day);
      if (dateMuscleMap[date] == null) {
        dateMuscleMap[date] = {};
      }
      dateMuscleMap[date]!.add(session.muscleId);
    }

    // Step 2: Aggregate by day of week
    final Map<int, int> dayOfWeekCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

    for (var entry in dateMuscleMap.entries) {
      final dayOfWeek = entry.key.weekday;
      dayOfWeekCounts[dayOfWeek] = (dayOfWeekCounts[dayOfWeek] ?? 0) + 
        (countMusclesTrained == true ? entry.value.length : 1);
    }
    return dayOfWeekCounts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(reportScreenProvider);
    final sessions = countMusclesTrained == true ? provider.filteredSessionsByDate : provider.filteredSessions;
    final groupedSessions = _groupSessionsByDayOfWeek(sessions);

    selectedMonth = provider.selectedMonth;
    selectedYear = provider.selectedYear;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit*2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
        children: [
          Text(
            "${countMusclesTrained ? "Muscles Trained" : "Sessions"} by Day of Week",
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.primaryColorDark),
          ),
          SizedBox(height: 12), // Space between the title and chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(20.0), // Padding inside the Container
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
                      reservedSize: 55, // Increase reserved size for the left titles
                      getTitlesWidget: (value, meta) {
                        return Align(
                          alignment: Alignment.centerLeft, // Align titles to the right
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0), // Add padding to move titles further from the axis
                            child: Text('${value.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Increase reserved size for the bottom titles
                      getTitlesWidget: (value, meta) {
                        final dayOfWeek = value.toInt();
                        final dayName = numToWeekDayName[dayOfWeek] ?? '';
                        return Align(
                          alignment: Alignment.bottomCenter, // Align titles to the bottom
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0), // Add padding to move titles further from the axis
                            child: Text(dayName, style: TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: groupedSessions.entries.map((entry) {
                  final dayOfWeek = entry.key;
                  final count = entry.value;
                  return BarChartGroupData(
                    x: dayOfWeek, 
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        color: theme.primaryColorDark,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
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
