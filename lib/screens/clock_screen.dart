import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_app/widgets/navigation_bar.dart';
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
  List<City> _cities = <City>[];

  _loadFavoriteCities() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? encodedFavoriteCities =
        preferences.getString('favorite_cities');

    if (encodedFavoriteCities != null) {
      setState(() => _cities = City.decode(encodedFavoriteCities));
    }
  }

  _saveFavoriteCities() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('favorite_cities', City.encode(_cities));
  }

  @override
  void initState() {
    super.initState();

    _loadFavoriteCities();
  }

  _onSearchReturn(dynamic city) {
    city = city as City;
    _saveFavoriteCities();

    setState(() {
      if (city != null) {
        _cities.add(city);
      }
    });
  }

  _onDeleteCity(int index) {
    _saveFavoriteCities();

    setState(() {
      _cities.removeAt(index);
    });
  }

  _onReorderCities(int oldIndex, int newIndex) {
    _saveFavoriteCities();

    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final City reorderedCity = _cities.removeAt(oldIndex);
      _cities.insert(newIndex, reorderedCity);
    });
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          shadowColor: Colors.black.withOpacity(0.3),
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
    var title = widget.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
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
                    onDelete: () => _onDeleteCity(index),
                  );
                },
                onReorder: _onReorderCities,
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
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
