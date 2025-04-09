import 'package:flutter/material.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/common/widgets/filter/provider/filter_provider.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common_layer/utils/date_labels.dart';
import 'package:gymini/common_layer/utils/text_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/domain_layer/entities/log_filter.dart';
import 'package:month_year_picker/month_year_picker.dart';

class FilterSection extends ConsumerWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);

    final theme = Theme.of(context);

    Future<void> selectDate() async{
      // showWarningSnackbar(context: context, message: 'Attempting to show MonthYearPicker');
      final selectedDate = await showMonthYearPicker(
        context: context,
        initialDate: DateTime(state.selectedYear, state.selectedMonth),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.primaryColor,
                onPrimary: AppColors.whiteColor,
                surface: theme.primaryColor,
                onSurface: theme.primaryColorDark,
                secondary: theme.primaryColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
              ),
            ),
            child: SizedBox(
              width: 200,
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 550), child: child!),
              ),
            ),
          );
        },
      );

      if (selectedDate != null) {
        // Compute the end date (start date + 1 month)
        final endDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
        // Read the global filter shared stream provider.
        final sharedStreams = ref.read(globalSharedStreamsProvider);
        // Create a new LogFilter. Preserve muscle and exercise if already selected.
        final newFilter = LogFilter(
          startYear: selectedDate.year,
          startMonth: selectedDate.month,
          endYear: endDate.year,
          endMonth: endDate.month,
          musclePicked: state.selectedMuscle,
          exercisePicked: state.selectedExercise,
        );
        sharedStreams.logFilterStream.update(newFilter);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical:GyminiTheme.verticalGapUnit),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Line: Month-Year Picker and Muscle Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: selectDate,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal:GyminiTheme.leftInnerPadding*2),
                  constraints: const BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
                  ),
                  child: Text(
                    '${clipText(numToMonthDict[state.selectedMonth]!, 3, false)}, ${state.selectedYear}',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Muscle selector
              Expanded(
  child: Container(
    padding: const EdgeInsets.all(12),
    height: 50,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
    ),
    child: DropdownButton<String>(
      underline: Container(),
      hint: Text(
        'Select Muscle',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
      ),
      value: state.selectedMuscle?.id,
      items: [
        const DropdownMenuItem<String>(
          value: '', 
          child: Text("Todos"), 
        ),
        ...state.allMuscles.map((muscle) {
          return DropdownMenuItem<String>(
            value: muscle.id,
            child: Text(clipText(muscle.name, 20)), // Limit text length
          );
        }),
      ],
      onChanged: (newValue) {
        notifier.selectMuscleById(newValue ?? '');
      },
    ),
  ),
),
            ],
          ),
          
          const SizedBox(height: 16), // Spacing between rows

          // Second Line: Exercise Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:GyminiTheme.leftInnerPadding*2),
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: Text(
                      'Select Exercise',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
                    ),
                    value: state.filteredExercises.any((e) => e.id == state.selectedExercise?.id)
                        ? state.selectedExercise?.id
                        : null,
                    items: state.filteredExercises.map((exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise.id,
                        child: Text(
                          clipText(exercise.name, 40),
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
                        ), // Limit text length
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        notifier.selectExerciseById(newValue);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
