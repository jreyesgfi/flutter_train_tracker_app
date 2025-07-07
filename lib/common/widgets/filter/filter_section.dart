import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymini/common/widgets/filter/provider/filter_provider.dart';
import 'package:gymini/common/shared_data/streams/global_stream_provider.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/common_layer/utils/text_utils.dart';
import 'package:tuple/tuple.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS & CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

enum DateFilterMode { month, year }

const List<String> _spanishMonths = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

// ─────────────────────────────────────────────────────────────────────────────
// MAIN FILTER SECTION
// ─────────────────────────────────────────────────────────────────────────────

class FilterSection extends ConsumerWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Date selector (month / year)
          DateFilterWidget(),
          SizedBox(height: 16),
          // Muscle selector
          MuscleFilterWidget(),
          // SizedBox(height: 16),
          // // Exercise selector
          // ExerciseFilterWidget(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATE FILTER WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class DateFilterWidget extends ConsumerStatefulWidget {
  const DateFilterWidget({super.key});

  @override
  ConsumerState<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends ConsumerState<DateFilterWidget> {
  late DateFilterMode _mode;
  late int _selectedMonth; // 1–12
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mode = DateFilterMode.month;
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _updateFilter(); // initialise provider with current month
  }

  // Updates global filter whenever a change occurs
  void _updateFilter() {
    final sharedStreams = ref.read(globalSharedStreamsProvider);
    DateTime start;
    DateTime end;

    if (_mode == DateFilterMode.month) {
      start = DateTime(_selectedYear, _selectedMonth, 1);
      end = DateTime(_selectedYear, _selectedMonth + 1, 1);
    } else {
      start = DateTime(_selectedYear, 1, 1);
      end = DateTime(_selectedYear + 1, 1, 1);
    }

    final filterState = ref.read(filterProvider);
    final newFilter = filterState.logFilter.copyWith(
      timeRange: Tuple2<DateTime, DateTime>(start, end),
    );
    sharedStreams.logFilterStream.update(newFilter);
  }

  // Toggle between month and year modes
  void _toggleMode() {
    setState(() {
      _mode = _mode == DateFilterMode.month ? DateFilterMode.year : DateFilterMode.month;
      final now = DateTime.now();
      if (_mode == DateFilterMode.month) {
        // reset year to current when switching to month mode
        _selectedYear = now.year;
      } else {
        // reset month to current when switching to year mode
        _selectedMonth = now.month;
      }
    });
    _updateFilter();
  }

  // Arrow navigation helpers
  void _increment() {
    setState(() {
      if (_mode == DateFilterMode.month) {
        _selectedMonth++;
        if (_selectedMonth > 12) {
          _selectedMonth = 1;
          _selectedYear++;
        }
      } else {
        _selectedYear++;
      }
    });
    _updateFilter();
  }

  void _decrement() {
    setState(() {
      if (_mode == DateFilterMode.month) {
        _selectedMonth--;
        if (_selectedMonth < 1) {
          _selectedMonth = 12;
          _selectedYear--;
        }
      } else {
        _selectedYear--;
      }
    });
    _updateFilter();
  }

  // Shows a picker list in a bottom sheet (long‑press)
  Future<void> _showPicker() async {
    final theme = Theme.of(context);

    int? selection = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        final List<int> items = _mode == DateFilterMode.month
            ? List<int>.generate(12, (i) => i + 1)
            : List<int>.generate(101, (i) => DateTime.now().year - 50 + i);
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final value = items[index];
            final isSelected = _mode == DateFilterMode.month
                ? value == _selectedMonth
                : value == _selectedYear;
            return ListTile(
              title: Text(
                _mode == DateFilterMode.month ? _spanishMonths[value - 1] : '$value',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? theme.primaryColor : theme.primaryColorDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () => Navigator.pop(context, value),
            );
          },
        );
      },
    );

    if (selection != null) {
      setState(() {
        if (_mode == DateFilterMode.month) {
          _selectedMonth = selection;
          // Each time we change month, default year to current year
          _selectedYear = DateTime.now().year;
        } else {
          _selectedYear = selection;
          // Each time we change year, default month to current month
          _selectedMonth = DateTime.now().month;
        }
      });
      _updateFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayValue = _mode == DateFilterMode.month
        ? '${_spanishMonths[_selectedMonth - 1]} $_selectedYear' // e.g. "Julio 2025"
        : _selectedYear.toString();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Anterior',
          onPressed: _decrement,
        ),
        // Expanded label that toggles mode (tap) & opens picker (long‑press)
        Expanded(
          child: GestureDetector(
            onTap: _toggleMode,
            onLongPress: _showPicker,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: GyminiTheme.leftInnerPadding * 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
              ),
              child: Text(
                displayValue,
                style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Siguiente',
          onPressed: _increment,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MUSCLE FILTER WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class MuscleFilterWidget extends ConsumerWidget {
  const MuscleFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final theme = Theme.of(context);

    // Sorted list of muscles for the dropdown
    final sortedMuscles = [...state.allMuscles]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
                'Filtro músculo',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
              ),
              value: state.logFilter.musclePicked?.id,
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('Todos'),
                ),
                ...sortedMuscles.map((muscle) {
                  return DropdownMenuItem<String>(
                    value: muscle.id,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        muscle.name,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: (newValue) => notifier.selectMuscleById(newValue ?? ''),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXERCISE FILTER WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class ExerciseFilterWidget extends ConsumerWidget {
  const ExerciseFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final theme = Theme.of(context);

    // Sorted list of exercises for the dropdown
    final sortedExercises = [...state.filteredExercises]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: GyminiTheme.leftInnerPadding * 2,
            ),
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(customThemeValues.borderRadius),
            ),
            child: DropdownButton<String>(
              underline: Container(),
              hint: Text(
                'Selecciona un ejercicio',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
              ),
              value: state.filteredExercises.any((e) => e.id == state.logFilter.exercisePicked?.id)
                  ? state.logFilter.exercisePicked?.id
                  : null,
              items: sortedExercises.map((exercise) {
                final bool isSelected = state.logFilter.exercisePicked?.id == exercise.id;
                return DropdownMenuItem<String>(
                  value: exercise.id,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 248),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primaryColor.withOpacity(0.2) : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? theme.primaryColor : theme.primaryColorDark,
                          width: 2,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      exercise.name,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColorDark),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  // If the selected id is tapped again, reset the selection.
                  if (newValue == state.logFilter.exercisePicked?.id) {
                    notifier.selectExerciseById('');
                  } else {
                    notifier.selectExerciseById(newValue);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
