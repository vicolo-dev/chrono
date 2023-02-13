// ignore_for_file: prefer_const_constructors

import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:flutter/material.dart';

class SettingGroupScreen extends StatefulWidget {
  const SettingGroupScreen(
      {super.key, required this.settingsGroup, required this.settings});

  final SettingGroup settingsGroup;
  final Settings settings;

  @override
  State<SettingGroupScreen> createState() => _SettingGroupScreenState();
}

class _SettingGroupScreenState extends State<SettingGroupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: Text(widget.settingsGroup.name,
            style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ...getSettingWidgets(
                widget.settings,
                settingItems: widget.settingsGroup.settingItems,
                checkDependentEnableConditions: () => setState(() {}),
                showExpandedView: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
