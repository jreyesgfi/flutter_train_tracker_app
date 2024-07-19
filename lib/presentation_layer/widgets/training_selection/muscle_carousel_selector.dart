 import 'package:flutter/material.dart';
 import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:provider/provider.dart';
 import 'muscle_tile.dart';
 
 class MuscleCarouselSelector extends ConsumerStatefulWidget {
  final List<MuscleTileSchema> muscles;

  const MuscleCarouselSelector({
    super.key,
    required this.muscles,
  });

  @override
  ConsumerState<MuscleCarouselSelector> createState() => _MuscleCarouselSelectorState();
}

class _MuscleCarouselSelectorState extends ConsumerState<MuscleCarouselSelector> {
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
                final muscleId = widget.muscles[index].muscleId;
                // Using ref.read to trigger actions without causing this widget to rebuild
                ref.read(trainingScreenProvider.notifier).selectMuscleById(muscleId);
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