import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String date;

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: theme.primaryColorDark, // Using the primary color from the theme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary), // Adjusted to use headline6 style
          ),
          Text(
            date,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onPrimary), // Adjusted to use subtitle1 style
          ),
        ],
      ),
    );
  }
}
