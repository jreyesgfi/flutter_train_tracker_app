import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/animation/entering_animation.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/settings/setting_elements.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/settings/setting_group_card.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorLight,  // Your desired background color
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 28.0),
        itemCount: settingsGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return EntryTransition(
            position: index + 1,
            child: SettingsGroupWidget(settingGroup: settingsGroups[index]),
          );
        },
      ),
    );
  }
}
