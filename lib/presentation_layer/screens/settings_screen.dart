import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:gymini/presentation_layer/widgets/settings/setting_elements.dart';
import 'package:gymini/presentation_layer/widgets/settings/setting_group_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return EntryTransition(
                  position: index + 1,
                  child:
                      SettingsGroupWidget(settingGroup: settingsGroups[index]),
                );
              },
              childCount: settingsGroups.length,
            ),
          ),
        )
      ],
    );
  }
}
