import 'package:clock_app/screens/search_city_screen.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/widgets/main_clock.dart';
import 'package:clock_app/widgets/timezone_card.dart';
import 'package:clock_app/types/city.dart';
import 'package:iconsax/iconsax.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key, required this.title});

  final String title;

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  int _selectedIndex = 0;

  final List<City> _cities = <City>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchReturn(dynamic city) {
    setState(() {
      if (city != null) {
        _cities.add(city);
      }
    });
  }

  void _onDeleteTimeZone(int index) {
    setState(() {
      _cities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const MainClock(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimeZoneCard(
                    city: _cities[index],
                    onDelete: () => _onDeleteTimeZone(index),
                  );
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
          ).then((value) {
            _onSearchReturn(value);
          });
        },
        tooltip: 'Increment',
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Iconsax.alarm)),
            // activeIcon: Icon(Iconsax.alarm5),r
            label: 'Alarms',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Iconsax.clock)),
            // activeIcon: Icon(Iconsax.clock5),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Iconsax.timer)),
            // activeIcon: Icon(Iconsax.timer4),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Iconsax.timer_1)),
            // activeIcon: Icon(Iconsax.timer_15),
            label: 'Stopwatch',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        unselectedFontSize: 10,

        // selectedIconTheme:
        selectedFontSize: 10,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
