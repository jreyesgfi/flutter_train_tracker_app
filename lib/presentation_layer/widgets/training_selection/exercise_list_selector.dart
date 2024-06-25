import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:provider/provider.dart';
import 'exercise_tile.dart';

class ExerciseListSelector extends StatefulWidget {
  final List<ExerciseTileSchema> exercises;

  const ExerciseListSelector({
    super.key,
    required this.exercises,
  });

  @override
  _ExerciseListSelectorState createState() => _ExerciseListSelectorState();
}

class _ExerciseListSelectorState extends State<ExerciseListSelector> {
  int? selectedIndex;
  Map<int, bool> completionStatus =
      {}; // Tracks completion status by exercise index

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          widget.exercises.length,
          (index) {
            bool isCompleted =
                completionStatus[index] ?? false; // Default to false if not set
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    completionStatus[index] = !isCompleted;
                  });

                  final exercise = widget.exercises[index];
                  Provider.of<TrainingScreenProvider>(context, listen:false).selectExerciseById(exercise.exerciseId);
                  Provider.of<TrainingScreenProvider>(context, listen: false).nextStage();
                },
                child: Container(
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 10),
                  child: ExerciseTile(
                    exercise: widget.exercises[index],
                    isSelected: selectedIndex == index,
                    isCompleted: isCompleted,
                  ),
                ));
          },
        ),
      ),
    );
  }
}
