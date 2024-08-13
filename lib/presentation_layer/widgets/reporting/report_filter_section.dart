import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/common_layer/utils/date_labels.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_application_test1/presentation_layer/providers/report_screen_provider.dart';

class ReportFilterSection extends ConsumerWidget {
  const ReportFilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportScreenProvider);
    final notifier = ref.read(reportScreenProvider.notifier);

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                print('Attempting to show MonthYearPicker');
                final selectedDate = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime(
                    state.selectedYear ?? DateTime.now().year,
                    state.selectedMonth ?? DateTime.now().month,
                  ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: ColorScheme.light(
                          primary: theme.primaryColor, // header background color
                          onPrimary: theme.primaryColorLight, // header text color
                          surface: theme.primaryColor,
                          onSurface: theme.primaryColorDark, // body text color
                          secondary: theme.primaryColor,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (selectedDate != null) {
                  notifier.selectMonthYear(
                      selectedDate.month, selectedDate.year);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius:
                      BorderRadius.circular(customThemeValues.borderRadius),
                ),
                child: Text(
                  '${state.selectedMonth != null ? '${numToMonthDict[state.selectedMonth]}' : 'Select Month'} ${state.selectedYear != null ? ', ${state.selectedYear}' : ''}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
