import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/domain_layer/entities/core_entities.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class SessionsHistoryCalendarWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(reportScreenProvider);
    final selectedYear = provider.selectedYear;
    final selectedMonth = provider.selectedMonth;
    final daysInMonth = _getDaysInMonth(selectedYear, selectedMonth);
    final sessionData = _groupSessionsByWeekAndDay(provider.filteredSessions);
    Map<int, int> intensityMap = {};

    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit*2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Sessions History",
          style: theme.textTheme.titleMedium
              ?.copyWith(color: theme.primaryColorDark),
        ),
        const SizedBox(height: 12),
        // Adding a SingleChildScrollView to make the chart horizontally scrollable
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
              maxY: 7, // Days of the week (1: Monday, 7: Sunday)
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              scatterSpots: _generateScatterSpots(sessionData, theme,
                  selectedYear, selectedMonth, daysInMonth, intensityMap),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48, // Reserve space for the Y-axis titles
                    getTitlesWidget: (value, meta) {
                      final dayName = [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ][value.toInt() - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(dayName, style: TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 7,
                    reservedSize: 40, // Reserve space for the X-axis titles
                    getTitlesWidget: (value, meta) {
                      //final day = value.toInt();
                      return Align(
                        alignment: Alignment
                            .bottomCenter, // Align titles to the bottom
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top:
                                  8.0), // Add padding to move titles further from the axis
                          child: Text('${value.toInt()}',
                              style: const TextStyle(fontSize: 12)),
                        ),
                      );
                    },
                  ),
                ),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              //Tooltip
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
                          text: '${day}/${selectedMonth}/${selectedYear}\n',
                          style: theme.textTheme.titleMedium
                            ?.copyWith(color: AppColors.whiteColor),
                        ),
                        TextSpan(
                          text: 'Ejercicios: $intensity',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.secondaryHeaderColor),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  List<ScatterSpot> _generateScatterSpots(
      List<Map<String, dynamic>> sessionData,
      ThemeData theme,
      int year,
      int month,
      int daysInMonth,
      Map<int, int> intensityMap) {
    final List<ScatterSpot> spots = [];
    final maxDaysInMonth = daysInMonth;
    final maxIntensity = sessionData.isEmpty ? 0 :
        sessionData.map((e) => e['intensity'] as int).reduce(max);

    // Iterate over possible day and day of the week combinations within the current month
    for (int day = 1; day <= maxDaysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dayOfWeek = date.weekday;
      final data = sessionData.firstWhere(
        (element) => element['day'] == day && element['weekday'] == dayOfWeek,
        orElse: () => {
          'day': day,
          'weekday': dayOfWeek,
          'intensity': 0
        }, // Return a default map if not found
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

  List<Map<String, dynamic>> _groupSessionsByWeekAndDay(
    List<SessionEntity> sessions,
  ) {
    final Map<int, Map<int, int>> dayWeekdayMap = {};

    for (var session in sessions) {
      final dayOfMonth = session.timeStamp.day;
      final dayOfWeek = session.timeStamp.weekday;

      if (!dayWeekdayMap.containsKey(dayOfMonth)) {
        dayWeekdayMap[dayOfMonth] = {};
      }
      if (!dayWeekdayMap[dayOfMonth]!.containsKey(dayOfWeek)) {
        dayWeekdayMap[dayOfMonth]![dayOfWeek] = 0;
      }
      dayWeekdayMap[dayOfMonth]![dayOfWeek] =
          (dayWeekdayMap[dayOfMonth]![dayOfWeek] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> result = [];
    for (var day in dayWeekdayMap.keys) {
      for (var weekday in dayWeekdayMap[day]!.keys) {
        final intensity = dayWeekdayMap[day]![weekday]!; // Adjust intensity as needed
        result.add({
          'day': day,
          'weekday': weekday,
          'intensity': intensity,
        });
      }
    }

    return result;
  }

  int _getDaysInMonth(int selectedYear, int selectedMonth) {
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }
}
