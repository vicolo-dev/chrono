import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/types/setting.dart';
import 'package:flutter/material.dart';

class SettingGroupCard extends StatelessWidget {
  final SettingGroup settingGroup;
  // final VoidCallback onTap;

  const SettingGroupCard({Key? key, required this.settingGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            // onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(settingGroup.icon, color: ColorTheme.textColor),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settingGroup.name,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        if (settingGroup.description.isNotEmpty)
                          Text(
                            settingGroup.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                      ],
                    )
                  ],
                ))));
  }
}
