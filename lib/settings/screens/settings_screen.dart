// ignore_for_file: prefer_const_constructors

import 'package:clock_app/settings/data/settings.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/widgets/setting_group_card.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // List<City> _favoriteCities = [];
  // List<City> _filteredCities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(FluxIcons.settings, semanticLabel: "Settings"),
            color: ColorTheme.textColor,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: settings.length,
          itemBuilder: (BuildContext context, int index) {
            SettingGroup settingGroup = settings[index];
            return SettingGroupCard(
              settingGroup: settingGroup,
              // onTap: () { },
            );
          },
        ),
      ),
    );
  }
}
