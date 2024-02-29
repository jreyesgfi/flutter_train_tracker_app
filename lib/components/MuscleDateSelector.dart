import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:intl/intl.dart';

class MuscleDateSelector extends StatefulWidget {
  final Function(List<Exercise>) onExercisesFetched;
  final bool needToFetch;

  const MuscleDateSelector({Key? key, required this.onExercisesFetched, required this.needToFetch})
      : super(key: key);

  @override
  _MuscleDateSelectorState createState() => _MuscleDateSelectorState();
}

class _MuscleDateSelectorState extends State<MuscleDateSelector> {
  String? _selectedMuscle;
  DateTime? _selectedDate;
  String _userId = '';

  final _formKey = GlobalKey<FormState>();

  @override
void didUpdateWidget(covariant MuscleDateSelector oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.needToFetch) {
    fetchExercises();
  }
}
  void fetchUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _userId = user.userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('UserId Error: $e')),
      );
    }
  }

  void fetchExercises() async {
    try {
      List<Exercise> allExercises = await Amplify.DataStore.query(
        Exercise.classType,
        where: Exercise.USERID.eq(_userId),
      );

      // Filter by muscle if specified
      if (_selectedMuscle != null) {
        allExercises = allExercises
            .where((exercise) => exercise.muscle == _selectedMuscle)
            .toList();
      }

      // Filter by date if specified
      if (_selectedDate != null) {
        allExercises = filterExercisesByDate(allExercises);
      }

      // Call the callback with the filtered list
      widget.onExercisesFetched(allExercises);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fetching Exercises Error: $e')),
        );
      }
    }
  }

  List<Exercise> filterExercisesByDate(List<Exercise> exercises) {
    // Convert selectedDate to TemporalDate for comparison
    TemporalDate temporalSelectedDate = TemporalDate(_selectedDate!);

    // Filter exercises for the selected date
    List<Exercise> selectedDateExercises = exercises
        .where((exercise) => exercise.date.compareTo(temporalSelectedDate) == 0)
        .toList();

    // Find the most recent session before the selected date
    TemporalDate? lastSessionDate;
    for (var exercise in exercises) {
      if (exercise.date.compareTo(temporalSelectedDate) < 0) {
        if (lastSessionDate == null ||
            exercise.date.compareTo(lastSessionDate) > 0) {
          lastSessionDate = exercise.date;
        }
      }
    }

    // Filter exercises for the last session date
    List<Exercise> lastSessionExercises = [];
    if (lastSessionDate != null) {
      lastSessionExercises = exercises
          .where((exercise) => exercise.date.compareTo(lastSessionDate!) == 0)
          .toList();
    }

    // Combine exercises from the selected date and the last session
    // No need to worry about duplicates since we're dealing with two distinct dates
    List<Exercise> combinedExercises = [
      ...selectedDateExercises,
      ...lastSessionExercises
    ];

    return combinedExercises;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Form(
        key: _formKey, // Ensure you've defined this key in your state class
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // To keep the column tight around its children
          children: [
            Row(
              children: [
                // Custom Date Selection Form Field
                Expanded(
                  child: DateSelectionFormField(
                    context: context,
                    initialDate: _selectedDate,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a date';
                      }
                      return null; // if the date is selected, validation passes
                    },
                    onSaved: (value) {
                      _selectedDate = value;
                    },
                  ),
                ),
                SizedBox(width: 10), // Spacing between elements
                // Muscle Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMuscle,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMuscle = newValue ?? '';
                      });
                      // Again, form submission will handle this part
                    },
                    items: const [
                      DropdownMenuItem(value: 'Pecho', child: Text('Pecho')),
                      DropdownMenuItem(value: 'Hombro', child: Text('Hombro')),
                      // Add other muscles as DropdownMenuItem
                    ],
                    decoration: InputDecoration(
                        labelText: "Select Muscle",
                        border:
                            OutlineInputBorder()), // Added border for consistency
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Trigger form submission and validation here
                  if (_formKey.currentState!.validate()) {
                    fetchExercises();
                  }
                },
                icon: Icon(Icons.search), // Icon for the button
                label: Text(
                    'Submit'), // Text is optional, can be omitted for an icon-only button
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Icon and text color
                  // Add other styling attributes as needed, like shape, elevation, etc.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom form field for date selection
class DateSelectionFormField extends FormField<DateTime> {
  DateSelectionFormField({
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialDate,
    required BuildContext context,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialDate,
          builder: (FormFieldState<DateTime> state) {
            return TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null) {
                  state.didChange(picked);
                }
              },
              child: Text(
                state.value == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(state.value!),
                style: TextStyle(
                    color: Colors.black), // Adjust text style as needed
              ),
            );
          },
        );
}
