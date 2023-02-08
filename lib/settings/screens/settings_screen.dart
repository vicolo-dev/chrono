// ignore_for_file: prefer_const_constructors

import 'package:clock_app/settings/data/settings_data.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/widgets/setting_group_card.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [...getSettingWidgets(appSettings)],
        ),
      ),
    );
  }
}
