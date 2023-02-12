// ignore_for_file: prefer_const_constructors

import 'package:clock_app/settings/data/settings_data.dart';
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
      appBar: AppBar(
        title: Text(widget.settingsGroup.name,
            style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ...getSettingWidgets(
              widget.settings,
              settingItems: widget.settingsGroup.settings,
              onChanged: () => setState(() {}),
            )
          ],
        ),
      ),
    );
  }
}
