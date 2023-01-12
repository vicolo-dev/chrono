import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/settings/screens/settings_screen.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/navigation/widgets/navigation_bar.dart';
import 'package:clock_app/icons/flux_icons.dart';

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key});

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorTheme.textColorSecondary,
                )),
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
            color: ColorTheme.textColorSecondary,
          ),
        ],
      ),
      body: Center(
        child: tabs[_selectedTabIndex].widget,
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedTabIndex: _selectedTabIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
