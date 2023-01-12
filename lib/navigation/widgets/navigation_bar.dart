import 'package:clock_app/navigation/data/tabs.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatefulWidget {
  final int selectedTabIndex;
  final void Function(int) onTabSelected;

  const AppNavigationBar(
      {Key? key, required this.selectedTabIndex, required this.onTabSelected})
      : super(key: key);

  @override
  _AppNavigationBarState createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              for (final tab in tabs)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.title,
                )
            ],
            currentIndex: widget.selectedTabIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: ColorTheme.textColorTertiary,
            showUnselectedLabels: false,
            selectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            iconSize: 24,
            type: BottomNavigationBarType.fixed,
            onTap: widget.onTabSelected,
          ),
        ),
      ),
    );
  }
}
