import 'package:flutter/material.dart';

import 'package:clock_app/icons/flux_icons.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({Key? key}) : super(key: key);

  @override
  _AppNavigationBarState createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _selectedTabIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FluxIcons.alarm),
          // activeIcon: Icon(Iconsax.alarm5),r
          label: 'Alarms',
        ),
        BottomNavigationBarItem(
          icon: Icon(FluxIcons.clock),
          // activeIcon: Icon(Iconsax.clock5),
          label: 'Clock',
        ),
        BottomNavigationBarItem(
          icon: Icon(FluxIcons.timer),
          // activeIcon: Icon(Iconsax.timer4),
          label: 'Timer',
        ),
        BottomNavigationBarItem(
          icon: Icon(FluxIcons.stopwatch),
          // activeIcon: Icon(Iconsax.timer_15),
          label: 'Stopwatch',
        ),
      ],
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      selectedLabelStyle: Theme.of(context).textTheme.titleSmall,
      unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
      iconSize: 24,
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
    );
  }
}
