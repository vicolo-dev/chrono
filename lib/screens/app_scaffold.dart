import 'package:clock_app/screens/tabs/clock_tab.dart';
import 'package:clock_app/screens/tabs/tabs.dart';
import 'package:clock_app/theme/color_theme.dart';
import 'package:clock_app/types/tab.dart';
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
            onPressed: () {},
            icon: const Icon(FluxIcons.settings, semanticLabel: "Settings"),
            color: ColorTheme.textColor,
          ),
        ],
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
            child: tabs[_selectedTabIndex].widget),
      ),
      // floatingActionButton: FloatingActionButton(
      //   mouseCursor: SystemMouseCursors.alias,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10.0),
      //   ),
      //   onPressed: screens[_selectedTabIndex].onFabPressed,
      //   tooltip: 'Add City',
      //   child: const Icon(
      //     FluxIcons.add,
      //     color: Colors.white,
      //   ),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: AppNavigationBar(
          selectedTabIndex: _selectedTabIndex, onTabSelected: _onTabSelected),
    );
  }
}
