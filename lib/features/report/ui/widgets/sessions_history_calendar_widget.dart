// lib/features/report/ui/widgets/sessions_history_calendar_widget.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/domain_layer/entities/core_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/features/report/provider/report_provider.dart'; // Updated import

class SessionsHistoryCalendarWidget extends ConsumerWidget {
  const SessionsHistoryCalendarWidget({super.key});

  /// Returns the number of days in the given month.
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Group sessions by week and day for a scatter chart.
  List<Map<String, dynamic>> _groupSessionsByWeekAndDay(List<SessionEntity> sessions) {
    final Map<int, Map<int, int>> dayWeekdayMap = {};

    for (var session in sessions) {
      final dayOfMonth = session.timeStamp.day;
      final dayOfWeek = session.timeStamp.weekday;

      dayWeekdayMap.putIfAbsent(dayOfMonth, () => {});
      dayWeekdayMap[dayOfMonth]!.update(dayOfWeek, (value) => value + 1, ifAbsent: () => 1);
    }

    final List<Map<String, dynamic>> result = [];
    dayWeekdayMap.forEach((day, weekdayMap) {
      weekdayMap.forEach((weekday, count) {
        result.add({
          'day': day,
          'weekday': weekday,
          'intensity': count,
        });
      });
    });

    return result;
  }

  /// Generates scatter spots for the sessions scatter chart.
  List<ScatterSpot> _generateScatterSpots(
      List<Map<String, dynamic>> sessionData,
      ThemeData theme,
      int year,
      int month,
      int daysInMonth,
      Map<int, int> intensityMap) {
    final List<ScatterSpot> spots = [];
    final maxDays = daysInMonth;
    final maxIntensity = sessionData.isEmpty ? 0 : sessionData.map((e) => e['intensity'] as int).reduce(max);

    // Create spots for each day in the month.
    for (int day = 1; day <= maxDays; day++) {
      final date = DateTime(year, month, day);
      final dayOfWeek = date.weekday;
      final data = sessionData.firstWhere(
        (element) =>
            element['day'] == day && element['weekday'] == dayOfWeek,
        orElse: () => {'day': day, 'weekday': dayOfWeek, 'intensity': 0},
      );
      final int intensity = data['intensity'] ?? 0;
      intensityMap[day] = intensity;
      double normalizedIntensity = maxIntensity > 0 ? (intensity / maxIntensity).clamp(0.0, 1.0) : 0.0;
      spots.add(
        ScatterSpot(
          day.toDouble(),
          dayOfWeek.toDouble(),
          dotPainter: FlDotCirclePainter(
            color: intensity > 0
                ? theme.primaryColor.withOpacity(normalizedIntensity)
                : theme.shadowColor.withOpacity(0.5),
            radius: 12,
            strokeWidth: 0,
          ),
        ),
      );
    }
    return spots;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Read report state from the new provider.
    final reportState = ref.watch(reportProvider);

    final selectedYear = reportState.selectedYear;
    final selectedMonth = reportState.selectedMonth;
    final daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);

    // Group sessions into a data structure for the scatter chart.
    final sessionData = _groupSessionsByWeekAndDay(reportState.filteredSessions);
    final Map<int, int> intensityMap = {};

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sessions History",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 12),
          Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
              color: AppColors.whiteColor,
            ),
            child: ScatterChart(
              ScatterChartData(
                minX: 1,
                maxX: daysInMonth.toDouble(),
                minY: 1,
                maxY: 7, // Days of the week: 1 (Monday) to 7 (Sunday)
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                scatterSpots: _generateScatterSpots(sessionData, theme, selectedYear, selectedMonth, daysInMonth, intensityMap),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      getTitlesWidget: (value, meta) {
                        final dayIndex = value.toInt() - 1;
                        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        final dayName = dayIndex >= 0 && dayIndex < dayNames.length ? dayNames[dayIndex] : '';
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(dayName, style: const TextStyle(fontSize: 12)),
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
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${value.toInt()}', style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: ScatterTouchTooltipData(
                    getTooltipItems: (ScatterSpot touchedSpot) {
                      final day = touchedSpot.x.toInt();
                      final intensity = intensityMap[day] ?? 0;
                      return ScatterTooltipItem(
                        '',
                        children: [
                          TextSpan(
                            text: '$day/$selectedMonth/$selectedYear\n',
                            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.whiteColor),
                          ),
                          TextSpan(
                            text: 'Ejercicios: $intensity',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.secondaryHeaderColor),
                          ),
                        ],
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
