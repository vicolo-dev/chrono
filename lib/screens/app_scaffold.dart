import 'package:clock_app/screens/tabs/clock_tab.dart';
import 'package:clock_app/screens/tabs/tabs.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/types/tab.dart';
import 'package:clock_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_app/widgets/layout/navigation_bar.dart';
import 'package:clock_app/icons/flux_icons.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.title});

  final String title;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[_selectedTabIndex].title,
            style: Theme.of(context).textTheme.titleMedium),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
          child: tabs[_selectedTabIndex].widget,
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedTabIndex: _selectedTabIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
