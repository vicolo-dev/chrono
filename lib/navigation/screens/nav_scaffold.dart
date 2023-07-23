import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/navigation/widgets/app_navigation_bar.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:flutter/material.dart';

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key});

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: Text(tabs[_selectedTabIndex].title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                )),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingGroupScreen(settingGroup: appSettings)));
            },
            icon: const Icon(FluxIcons.settings, semanticLabel: "Settings"),
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
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
