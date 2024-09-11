import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/like_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MuscleTileSchema {
  final String muscleId;
  final String label;
  final int timeSinceExercise; //days
  final String imagePath;
  final bool liked;

  MuscleTileSchema({
    required this.muscleId,
    required this.label,
    required this.timeSinceExercise,
    required this.imagePath,
    required this.liked,
  });
}

class MuscleTile extends StatefulWidget {
  final MuscleTileSchema muscle;
  final bool isSelected;
  final Function toggleLike;

  const MuscleTile({
    super.key,
    required this.muscle,
    this.isSelected = false,
    required this.toggleLike,

  });

  @override
  _MuscleTileState createState() => _MuscleTileState();
}

class _MuscleTileState extends State<MuscleTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomTheme>();

    return MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: Align(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            width: widget.isSelected ? 140 : 120,
            height: widget.isSelected ? 140 : 120,
            decoration: BoxDecoration(
              color: widget.isSelected ? theme.shadowColor : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(customTheme?.properties.borderRadius ?? 0.0),
              border: Border.all(
                  color: isHovering ? theme.primaryColorDark : Colors.transparent,
                  width: 2),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      widget.muscle.imagePath,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 5,
                  left: 80,
                  top: 80,
                  bottom: 5,
                  child:LikeButton(
                    isLiked: widget.muscle.liked, // This should come from your state management
                    onLike: () {
                      widget.toggleLike(widget.muscle.muscleId);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isHovering ? 0.3 : 1.0), // Adjust opacity based on hovering
                      borderRadius: BorderRadius.circular(customTheme?.properties.borderRadius ?? 0.0),
                    ),
                    child: Text(
                      '${widget.muscle.timeSinceExercise <365 ?
                          widget.muscle.timeSinceExercise.toString()
                          : "ထ"
                        } días',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _handleHover(bool hovering) {
    setState(() {
      isHovering = hovering;
    });
  }
}
