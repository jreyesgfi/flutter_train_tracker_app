import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/settings/setting_elements.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/settings/setting_group_card.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical:28.0),
        itemCount: settingsGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return SettingsGroupWidget(settingGroup: settingsGroups[index]);
        });
    
  }
}
