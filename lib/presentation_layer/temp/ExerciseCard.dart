import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_test1/common_layer/utils/is_same_day.dart';
import 'package:flutter_application_test1/models/muscles_and_exercises.dart';
import 'package:flutter_application_test1/presentation_layer/screens/main_screen.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/CustomDropdownFormField.dart';

import 'package:flutter_application_test1/common_layer/theme/custom_colors.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/next_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_test1/models/Exercise.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/roulette_numeric_input.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDeleteSuccess;

  ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onDeleteSuccess,
  }) : super(key: key);

  void _deleteEntry(BuildContext context) async {
    try {
      await Amplify.DataStore.delete(exercise);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry deleted successfully!')),
      );
      onDeleteSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color:
            Theme.of(context).canvasColor, // Use the theme's background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${exercise.exercise}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                SizedBox(height: 4), // Adjust spacing
                Text(
                    "${DateFormat('yyyy-MM-dd').format(exercise.date.getDateTime())}",
                    style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 8), // Adjust spacing for visual separation
                Text("Weight: ${exercise.maxWeight} / ${exercise.minWeight}",
                    style: TextStyle(fontSize: 16.0)),
                Text("Reps: ${exercise.maxReps} / ${exercise.minReps}",
                    style: TextStyle(fontSize: 16.0)),
                // Additional exercise details can be added here as needed
              ],
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                onPressed: () => _deleteEntry(
                    context), // Ensure this method is defined to accept BuildContext
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableExerciseCard extends StatefulWidget {
  final String userId;
  final VoidCallback onPublishSuccess;

  EditableExerciseCard({
    Key? key,
    required this.userId,
    required this.onPublishSuccess,
  }) : super(key: key);

  @override
  _EditableExerciseCardState createState() => _EditableExerciseCardState();
}

class _EditableExerciseCardState extends State<EditableExerciseCard> {
  late TextEditingController _exerciseController;
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;
  var _lastExercise;

  String? _selectedExercise;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(text: '');
    _maxWeightController = TextEditingController(text: '0');
    _minWeightController = TextEditingController(text: '0');
    _maxRepsController = TextEditingController(text: '0');
    _minRepsController = TextEditingController(text: '0');

    // _maxWeightPicker= NumericRoulettePicker(
    //           label: "Max Weight",
    //           controller: _maxWeightController,
    //           allowDecimal: true,
    //         );
    // _minWeightPicker = NumericRoulettePicker(
    //           label: "Min Weight",
    //           controller: _minWeightController,
    //           allowDecimal: true,
    //         );
    // _maxRepsPicker = NumericRoulettePicker(
    //           label: "Max Reps",
    //           controller: _maxRepsController,
    //         );
    // _minRepsPicker = NumericRoulettePicker(
    //           label: "Min Reps",
    //           controller: _minRepsController,
    //         );
  }

  //dispose the controllers
  @override
  void dispose() {
    _exerciseController.dispose();
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  void _publishEntry(context) async {
    final staticModel =
        Provider.of<MuscleDateSelectionProvider>(context, listen: false);
    final selectedMuscle = staticModel.selectedMuscle;
    final selectedDate = staticModel.selectedDate;

    // Assuming you have a method to create or update the exercise
    final newExercise = Exercise(
      // updatedAt: TemporalDateTime.now(),
      userId: widget.userId,
      date: TemporalDate(selectedDate),
      muscle: selectedMuscle,
      exercise: _selectedExercise ?? '',
      maxWeight: double.tryParse(_maxWeightController.text),
      minWeight: double.tryParse(_minWeightController.text),
      maxReps: int.tryParse(_maxRepsController.text),
      minReps: int.tryParse(_minRepsController.text),
    );

    try {
      await Amplify.DataStore.save(newExercise);
      widget.onPublishSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error publishing entry: $e')));
    }
  }

  void _updateSelectedExercise(String? value) async {
    if (value == null) {
      return;
    }
    final lastExercise = await _getLastExerciseWithName(value);
    setState(() {
      _selectedExercise = value;
      if (lastExercise != null) {
        _lastExercise = lastExercise;
        // _maxWeightController.text = _lastExercise!.maxWeight.toString();
        // _minWeightController.text = _lastExercise!.minWeight.toString();
        // _maxRepsController.text = _lastExercise!.maxReps.toString();
        // _minRepsController.text = _lastExercise!.minReps.toString();
      }
    });
  }

  Future<Exercise?> _getLastExerciseWithName(String name) async {
    try {
      // Access ExerciseProvider from the context
      final exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);
      final List<Exercise> exercises = exerciseProvider.allExercises
          .where((exercise) => exercise.exercise == name)
          .toList();

      // Sort by date descending and get the first one if available
      exercises
          .sort((a, b) => b.date.getDateTime().compareTo(a.date.getDateTime()));
      if (exercises.isNotEmpty) {
        return exercises.first;
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget exerciseDropdown() {
      return Consumer2<MuscleDateSelectionProvider, ExerciseProvider>(
        builder: (context, dateModel, exerciseModel, child) {
          final selectedDate = dateModel.selectedDate;
          List<String> muscleExercises =
              exercisesByMuscle[dateModel.selectedMuscle] ?? [];

          // Filter or mark exercises that have been done on the selected date
          final doneExercises = exerciseModel.allExercises
              .where((exercise) =>
                  isSameDay(exercise.date.getDateTime(), selectedDate)&&
                  muscleExercises.contains(exercise.exercise))
              .map((e) => e.exercise)
              .toSet();
          print(doneExercises);
          return CustomDropdownFormField(
            initialValue: _selectedExercise,
            onChanged: (value) {
              if (!doneExercises.contains(value)) {
                _updateSelectedExercise(value);
              }
              // Otherwise, do not update the selection
            },
            items: muscleExercises.map((String value) {
              bool isDone = doneExercises.contains(value);
              return CustomDropdownItem(
                value: value,
                available: !isDone, // Set to false if the exercise is done
              );
            }).toList(),
            hintText: "Select Exercise",
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Use the theme's background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // This Row will contain the dropdown and another widget horizontally
              children: [
                Flexible(
                  // Use Expanded to ensure the dropdown takes minimal necessary space
                  flex:
                      4, // Adjust the flex factor based on how much space you want the dropdown to take relative to other elements
                  child: exerciseDropdown(), // Your dropdown widget
                ),
                Flexible(
                  // Another widget (for illustration, let's use a placeholder)
                  flex: 2, // Adjust based on your layout needs
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4), // Example padding
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            // Other widgets like NumericRoulettePicker can follow here, outside the Row
            // _maxWeightPicker,
            // _minWeightPicker,
            // _maxRepsPicker,
            // _minRepsPicker,
            NumericRoulettePicker(
              label: "Max Weight",
              controller: _maxWeightController,
              allowDecimal: true,
              value: _lastExercise?.maxWeight ?? 0,
            ),
            NumericRoulettePicker(
              label: "Min Weight",
              controller: _minWeightController,
              allowDecimal: true,
              value: _lastExercise?.minWeight ?? 0,
            ),
            NumericRoulettePicker(
              label: "Max Reps",
              controller: _maxRepsController,
              value: _lastExercise?.maxReps.toDouble() ?? 0,
            ),
            NumericRoulettePicker(
              label: "Min Reps",
              controller: _minRepsController,
              value: _lastExercise?.minReps.toDouble() ?? 0,
            ),
            Builder(
              builder: (context) {
                return NextIconButton(
                  onTap: () => _publishEntry(context),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
