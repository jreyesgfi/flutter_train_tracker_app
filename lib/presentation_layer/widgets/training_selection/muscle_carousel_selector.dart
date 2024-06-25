import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:provider/provider.dart';
import 'muscle_tile.dart';

class MuscleCarouselSelector extends StatefulWidget {
  final List<MuscleTileSchema> muscles;

  const MuscleCarouselSelector({
    super.key,
    required this.muscles,
  });

  @override
  _MuscleCarouselSelectorState createState() => _MuscleCarouselSelectorState();
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
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                final muscle = widget.muscles[index];
                Provider.of<TrainingScreenProvider>(context, listen: false).selectMuscleById(muscle.muscleId);
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 10 : 0, right: 10),
              child: MuscleTile(
                muscle: widget.muscles[index],
                isSelected: selectedIndex == index,
              ),
            ),
          );
        },
      ),
    );
  }
}