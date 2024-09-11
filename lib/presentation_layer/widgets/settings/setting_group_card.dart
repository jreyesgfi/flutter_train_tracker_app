import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/settings/setting_elements.dart';

class SettingsGroupWidget extends StatelessWidget {
  final SettingGroup settingGroup;

  const SettingsGroupWidget({super.key, required this.settingGroup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 20.0, left:6.0, bottom : 4.0),
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
            padding: const EdgeInsets.all(8.0),
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
