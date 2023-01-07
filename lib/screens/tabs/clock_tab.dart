import 'package:clock_app/data/preferences.dart';
import 'package:clock_app/screens/search_city_screen.dart';
import 'package:clock_app/types/city.dart';
import 'package:clock_app/widgets/layout/FAB.dart';
import 'package:clock_app/widgets/clock.dart';
import 'package:clock_app/widgets/timezone_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClockTab extends StatefulWidget {
  const ClockTab({Key? key}) : super(key: key);

  @override
  _ClockTabState createState() => _ClockTabState();
}

class _ClockTabState extends State<ClockTab> {
  List<City> _cities = <City>[];

  @override
  void initState() {
    super.initState();

    setState(() => _cities = Preferences.getFavoriteCities());
  }

  _onSearchReturn(dynamic city) {
    setState(() {
      if (city != null) {
        _cities.add(city);
      }
    });

    Preferences.saveFavoriteCities(_cities);
  }

  _onDeleteCity(int index) {
    setState(() {
      _cities.removeAt(index);
    });

    Preferences.saveFavoriteCities(_cities);
  }

  _onReorderCities(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final City reorderedCity = _cities.removeAt(oldIndex);
      _cities.insert(newIndex, reorderedCity);
    });

    Preferences.saveFavoriteCities(_cities);
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
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
    return Stack(children: [
      Column(children: [
        Clock(
          shouldShowDate: true,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: ReorderableListView.builder(
              proxyDecorator: _proxyDecorator,
              itemCount: _cities.length,
              itemBuilder: (BuildContext context, int index) {
                return TimeZoneCard(
                  key: ValueKey(_cities[index]),
                  city: _cities[index],
                  onDelete: () => _onDeleteCity(index),
                );
              },
              footer: const SizedBox(height: 72),
              onReorder: _onReorderCities,
            ),
          ),
        ),
      ]),
      FAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCityScreen()),
          ).then(_onSearchReturn);
        },
      )
    ]);
  }
}
