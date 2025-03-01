import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/widgets/training_selection/muscle_tile.dart';

class MuscleCarouselSelector extends StatefulWidget {
  final List<MuscleTileSchema> muscles;
  final void Function(String muscleId) onMuscleSelected;
  final void Function(String muscleId) onToggleLike;

  const MuscleCarouselSelector({
    super.key,
    required this.muscles,
    required this.onMuscleSelected,
    required this.onToggleLike,
  });

  @override
  State<MuscleCarouselSelector> createState() => _MuscleCarouselSelectorState();
}

class _MuscleCarouselSelectorState extends State<MuscleCarouselSelector> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: widget.muscles.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final muscleTile = widget.muscles[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // Notify the parent (or provider) which muscle was selected
              widget.onMuscleSelected(muscleTile.muscleId);
            },
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 10 : 0, right: 10),
              child: MuscleTile(
                muscle: muscleTile,
                isSelected: selectedIndex == index,
                toggleLike: (muscleId) => widget.onToggleLike(muscleId),
              ),
            ),
          );
        },
      ),
    );
  }
}
