import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set locale to Spanish
    Intl.defaultLocale = 'es_ES';
    final dayMonthYear = DateFormat('d EEEE').format(date); // "Septiembre 10, 2024"
    final dayOfWeek = DateFormat('MMMM, yyyy').format(date); // "Sábado"

    return Container(
      alignment: Alignment.center,
      width: 300,
      margin: const EdgeInsets.only(top:30, bottom:4),
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.primaryColorDark, width: 2), // Top border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayMonthYear, // First line for the month, day, year
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          SizedBox(height: 8,),
          Text(
            dayOfWeek, // Second line for the weekday
            style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColorDark, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
