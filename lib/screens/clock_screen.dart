import 'package:clock_app/data/database.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/widgets/main_clock.dart';
import 'package:clock_app/screens/search_city_screen.dart';
import 'package:clock_app/widgets/timezone_card.dart';
import 'package:clock_app/types/city.dart';
import 'package:clock_app/icons/flux_icons.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key, required this.title});

  final String title;

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  int _selectedIndex = 0;

  final List<City> _cities = <City>[];

  @override
  void initState() {
    super.initState();

    database?.rawQuery('SELECT * FROM SavedCities').then((List<Map> value) {
      setState(() {
        _cities.addAll(value.map((Map map) => City.fromMap(map)));
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchReturn(dynamic city) {
    city = city as City;
    database?.rawInsert(
        'INSERT INTO SavedCities(City, Timezone, Country) VALUES("${city.name}", "${city.timezone}", "${city.country}")');
    setState(() {
      if (city != null) {
        _cities.add(city);
      }
    });
  }

  void _onDeleteTimeZone(int index) {
    database?.rawDelete(
        'DELETE FROM SavedCities WHERE City = "${_cities[index].name}"');
    setState(() {
      _cities.removeAt(index);
    });
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          shadowColor: Colors.black.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          elevation: 4,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FluxIcons.settings, semanticLabel: "Settings"),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const MainClock(),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                proxyDecorator: proxyDecorator,
                itemCount: _cities.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimeZoneCard(
                    key: ValueKey(_cities[index]),
                    city: _cities[index],
                    onDelete: () => _onDeleteTimeZone(index),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final City reorderedCity = _cities.removeAt(oldIndex);
                    _cities.insert(newIndex, reorderedCity);
                  });
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mouseCursor: SystemMouseCursors.alias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchCityScreen(existingCities: _cities)),
          ).then(_onSearchReturn);
        },
        tooltip: 'Add City',
        child: const Icon(
          FluxIcons.add,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(FluxIcons.alarm)),
            // activeIcon: Icon(Iconsax.alarm5),r
            label: 'Alarms',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(FluxIcons.clock)),
            // activeIcon: Icon(Iconsax.clock5),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(FluxIcons.timer)),
            // activeIcon: Icon(Iconsax.timer4),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(FluxIcons.stopwatch)),
            // activeIcon: Icon(Iconsax.timer_15),
            label: 'Stopwatch',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: Theme.of(context).textTheme.displaySmall,
        unselectedLabelStyle: Theme.of(context).textTheme.displaySmall,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
