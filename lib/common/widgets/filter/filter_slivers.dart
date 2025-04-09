// SliverPersistentHeader delegate for the sticky filter section
import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/common/widgets/filter/filter_section.dart';

class SliverFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
      ),
      child: const EntryTransition(
        position: 1,
        totalAnimations: 6,
        child: FilterSection(),
      ),
    );
  }

  @override
  double get maxExtent => 140;
  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Return true if the header should rebuild when scrolled
  }
}