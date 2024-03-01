import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:flutter_application_test1/models/muscles_and_exercises.dart';
import 'package:flutter_application_test1/screens/main_screen.dart';
import 'package:flutter_application_test1/theme/components/CustomDropdownFormField.dart';
import 'package:flutter_application_test1/theme/components/DateSelectorFormField.dart';
import 'package:flutter_application_test1/theme/components/NextButton.dart';

import 'package:provider/provider.dart';

class MuscleDateSelector extends StatefulWidget {
  final Function(List<Exercise>) onExercisesFetched;
  final bool needToFetch;

  const MuscleDateSelector(
      {Key? key, required this.onExercisesFetched, required this.needToFetch})
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
  void initState() {
    super.initState();
    fetchUserId();
  }

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

  void onDatePicked(context, DateTime pickedDate) {
    setState(() {
      _selectedDate = pickedDate;
    });
    Provider.of<MuscleDateSelectionModel>(context, listen: false)
        .updateDate(pickedDate);
  }

  void onMusclePicked(context, String pickedMuscle) {
    setState(() {
      _selectedMuscle = pickedMuscle;
    });
    Provider.of<MuscleDateSelectionModel>(context, listen: false)
        .updateMuscle(pickedMuscle);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date Selection Field
                Flexible(
                  flex: 5, // Adjust flex factor based on your needs
                  child: DateSelectionFormField(
                    context: context,
                    initialDate: null,
                    onDatePicked: (pickedDate) {
                      onDatePicked(context, pickedDate);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ), // Adjust spacing as needed
                // Muscle Dropdown Field
                Flexible(
                  flex: 5, // Adjust flex factor based on your needs
                  child: CustomDropdownFormField(
                    initialValue: null,
                    onChanged: (pickedMuscle) {
                      if (pickedMuscle != null) {
                        onMusclePicked(context, pickedMuscle);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a muscle';
                      }
                      return null;
                    },
                    items: muscles.map((String muscle) {
                      return DropdownMenuItem<String>(
                          value: muscle, child: Text(muscle));
                    }).toList(),
                    hintText: "Select Muscle",
                  ),
                ),
                
                NextButton(onTap: ()=> {
                  if (_formKey.currentState!.validate()) {
                    fetchExercises()
                  }
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
