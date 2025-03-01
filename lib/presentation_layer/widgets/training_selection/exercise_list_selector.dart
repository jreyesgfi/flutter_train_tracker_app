import 'package:flutter/material.dart';
import 'exercise_tile.dart';


class ExerciseListSelector extends StatefulWidget {
  final List<ExerciseTileSchema> exercises;
  final void Function(String exerciseId) onExerciseSelected;
  final void Function(String exerciseId) onToggleLike;

  const ExerciseListSelector({
    super.key,
    required this.exercises,
    required this.onExerciseSelected,
    required this.onToggleLike,
  });

  @override
  State<ExerciseListSelector> createState() => _ExerciseListSelectorState();
}

class _ExerciseListSelectorState extends State<ExerciseListSelector> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final exercises = widget.exercises;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(exercises.length, (index) {
          final exerciseTile = exercises[index];
          final isCompleted = (exerciseTile.timeSinceExercise == 0);

          return GestureDetector(
            onTap: () {
              if (isCompleted) {
                // Show a warning or do something else
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ejercicio ya completado hoy")),
                );
                return;
              }
              setState(() {
                selectedIndex = index;
              });
              widget.onExerciseSelected(exerciseTile.exerciseId);
            },
            child: Container(
              margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 10),
              child: ExerciseTile(
                exercise: exerciseTile,
                isSelected: (selectedIndex == index),
                isCompleted: isCompleted,
                toggleLike: (exerciseId) => widget.onToggleLike(exerciseId),
              ),
            ),
          );
        }),
      ),
    );
  }
}
