import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/navigation/widgets/app_navigation_bar.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key});

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
  int _selectedTabIndex = 0;
  bool useMaterialNavBar  = false;
  late Setting useMaterialNavBarSetting;

  void _onTabSelected(int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    setState(() {
      _selectedTabIndex = index;
    });
  }
void setUseMaterialnavBar(dynamic value) {
    setState(() {
      useMaterialNavBar = value;
    });
  }

  @override
  void initState() {
    super.initState();
    useMaterialNavBarSetting = appSettings
        .getGroup("Appearance")
        .getGroup("Style")
        .getSetting("Use Material Style");
    setUseMaterialnavBar(useMaterialNavBarSetting.value);
    useMaterialNavBarSetting.addListener(setUseMaterialnavBar);
  }

  @override
  void dispose() {
    useMaterialNavBarSetting.removeListener(setUseMaterialnavBar);
    super.dispose();
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
      extendBody: false,
      body: Center(
        child: tabs[_selectedTabIndex].widget,
      ),
      bottomNavigationBar: useMaterialNavBar ?  
NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedTabIndex,
        onDestinationSelected:_onTabSelected ,
        destinations: <Widget>[
          for (final tab in tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.title,
              )
        ],
      ) :     
      AppNavigationBar(
        selectedTabIndex: _selectedTabIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
