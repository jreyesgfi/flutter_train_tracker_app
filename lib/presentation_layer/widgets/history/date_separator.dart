import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use the formatDate method to format the date
    final formattedDate = DateSeparator.formatDate(date);

    return Container(
      alignment: Alignment.center,
      width: 300,
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
            formattedDate.dayMonthYear, // First line for the day and date
            style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate.monthYear, // Second line for the month and year
            style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColorDark, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  // Static method to format the date, useful for consistency across the app
  static _FormattedDate formatDate(DateTime date) {
    // Ensure the locale is set for Spanish formatting
    Intl.defaultLocale = 'es_ES';

    // Format day and weekday
    final String dayMonthYear = DateFormat('d EEEE').format(date); // "10 Sábado"
    final String monthYear = DateFormat('MMMM, yyyy').format(date); // "Septiembre, 2024"

    return _FormattedDate(dayMonthYear, monthYear);
  }
}

// Private class to return both date formats together
class _FormattedDate {
  final String dayMonthYear;
  final String monthYear;

  _FormattedDate(this.dayMonthYear, this.monthYear);
}
