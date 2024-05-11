import 'dart:async';

import 'package:clock_app/alarm/logic/new_alarm_snackbar.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/navigation/types/tab.dart';
import 'package:clock_app/navigation/widgets/app_navigation_bar.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/system/logic/handle_intents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:receive_intent/receive_intent.dart' as intent_handler;

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
  late int _selectedTabIndex;
  late Setting useMaterialNavBarSetting;
  late Setting swipeActionSetting;
  late StreamSubscription _sub;
  late PageController _controller;

  void _onTabSelected(int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    setState(() {
      _controller.jumpToPage(index);
      _selectedTabIndex = index;
    });
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _selectedTabIndex = currentPageIndex;
    });
  }

  void update(dynamic value) {
    setState(() {});
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      DateTime? nextScheduleDateTime = alarm.currentScheduleDateTime;
      if (nextScheduleDateTime == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackbar(getNewAlarmSnackbarText(alarm), fab: true, navBar: true));
    });
  }

  Future<void> initReceiveIntent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final receivedIntent =
          await intent_handler.ReceiveIntent.getInitialIntent();
      if (mounted) {
        handleIntent(
            receivedIntent, context, _showNextScheduleSnackBar, _onTabSelected);
      }
    } on PlatformException {
      // Handle exception
    }

    _sub = intent_handler.ReceiveIntent.receivedIntentStream.listen(
        (intent_handler.Intent? receivedIntent) {
      if (receivedIntent != null) {
        handleIntent(
            receivedIntent, context, _showNextScheduleSnackBar, _onTabSelected);
      }
      // Validate receivedIntent and warn the user, if it is not correct,
    }, onError: (err) {
      // Handle exception
    });
  }

  @override
  void initState() {
    super.initState();
    initReceiveIntent();
    useMaterialNavBarSetting = appSettings
        .getGroup("Appearance")
        .getGroup("Style")
        .getSetting("Use Material Style");
    swipeActionSetting =
        appSettings.getGroup("General").getSetting("Swipe Action");
    swipeActionSetting.addListener(update);
    useMaterialNavBarSetting.addListener(update);
    _controller = PageController(initialPage: widget.initialTabIndex);
    _selectedTabIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    useMaterialNavBarSetting.removeListener(update);
    swipeActionSetting.removeListener(update);
    _sub.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final tabs = getTabs(context);
    return Scaffold(
      appBar: orientation == Orientation.portrait
          ? AppTopBar(
              title: Text(
                tabs[_selectedTabIndex].title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
              ),
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
                  icon:
                      const Icon(FluxIcons.settings, semanticLabel: "Settings"),
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                ),
              ],
            )
          : null,
      extendBody: false,
      body: SafeArea(
        child: Row(
          children: [
            if (orientation == Orientation.landscape)
              NavigationRail(
                destinations: [
                  for (final tab in tabs)
                    NavigationRailDestination(
                      icon: Icon(tab.icon),
                      label: Text(tab.title),
                    )
                ],
                leading: Text(tabs[_selectedTabIndex].title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                        )),
                trailing: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SettingGroupScreen(settingGroup: appSettings)));
                  },
                  icon:
                      const Icon(FluxIcons.settings, semanticLabel: "Settings"),
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                ),
                selectedIndex: _selectedTabIndex,
                onDestinationSelected: _onTabSelected,
              ),
            Expanded(
              child: PageView(
                  controller: _controller,
                  onPageChanged: _handlePageViewChanged,
                  physics: swipeActionSetting.value == SwipeAction.cardActions
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: tabs.map((tab) => tab.widget).toList()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: orientation == Orientation.portrait
          ? useMaterialNavBarSetting.value
              ? NavigationBar(
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  selectedIndex: _selectedTabIndex,
                  onDestinationSelected: _onTabSelected,
                  destinations: <Widget>[
                    for (final tab in tabs)
                      NavigationDestination(
                        icon: Icon(tab.icon),
                        label: tab.title,
                      )
                  ],
                )
              : AppNavigationBar(
                  selectedTabIndex: _selectedTabIndex,
                  onTabSelected: _onTabSelected,
                )
          : null,
    );
  }
}
