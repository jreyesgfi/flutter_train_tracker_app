import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/widgets/settings/setting_elements.dart';

class SettingsGroupWidget extends StatelessWidget {
  final SettingGroup settingGroup;

  const SettingsGroupWidget({super.key, required this.settingGroup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: GyminiTheme.verticalGapUnit*3, bottom : GyminiTheme.verticalGapUnit),
        child: Text(
              settingGroup.title,
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColorDark),
        )
        )
       ,
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.transparent,
          color: AppColors.whiteColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: GyminiTheme.verticalGapUnit),
            child: Column(
              children: settingGroup.items.map((item) {
                return ListTile(
                  leading:
                      Icon(item.icon, color: theme.primaryColor),
                  title: Text(
                    item.label,
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.primaryColorDark),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => item.onTap(context),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
