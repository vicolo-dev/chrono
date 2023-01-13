import 'package:clock_app/common/utils/list_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:clock_app/clock/screens/search_city_screen.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/clock/data/favorite_cities.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/clock.dart';
import 'package:clock_app/common/widgets/fab.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  List<City> _cities = [];

  @override
  void initState() {
    super.initState();
    setState(() => _cities = loadList('favorite_cities'));
  }

  _onSearchReturn(dynamic city) {
    setState(() {
      if (city != null) {
        _cities.add(city);
      }
    });

    saveList('favorite_cities', _cities);
  }

  _onDeleteCity(int index) {
    setState(() {
      _cities.removeAt(index);
    });

    saveList('favorite_cities', _cities);
  }

  _onReorderCities(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final City reorderedCity = _cities.removeAt(oldIndex);
      _cities.insert(newIndex, reorderedCity);
    });

    saveList('favorite_cities', _cities);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Clock(
            shouldShowDate: true,
            shouldShowSeconds: true,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              proxyDecorator: reorderableListDecorator,
              itemCount: _cities.length,
              itemBuilder: (BuildContext context, int index) {
                return TimeZoneCard(
                  key: ValueKey(_cities[index]),
                  city: _cities[index],
                  onDelete: () => _onDeleteCity(index),
                );
              },
              footer: const SizedBox(
                  height: 64), // Allows the last item to not be covered by FAB
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
