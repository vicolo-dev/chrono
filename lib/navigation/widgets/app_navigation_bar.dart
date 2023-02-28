import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/navigation/widgets/nav_bar.dart';
import 'package:clock_app/navigation/widgets/nav_bar_item.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatefulWidget {
  final int selectedTabIndex;
  final void Function(int) onTabSelected;

  const AppNavigationBar(
      {Key? key, required this.selectedTabIndex, required this.onTabSelected})
      : super(key: key);

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 0),
      child: CardContainer(
        elevationMultiplier: 2,
        child: BottomNavBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            for (final tab in tabs)
              BottomNavBarItem(
                icon: Icon(tab.icon),
                label: tab.title,
              )
          ],
          currentIndex: widget.selectedTabIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
          showUnselectedLabels: false,
          selectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          iconSize: 24,
          type: BottomNavBarType.fixed,
          onTap: widget.onTabSelected,
        ),
      ),
    );
  }
}
