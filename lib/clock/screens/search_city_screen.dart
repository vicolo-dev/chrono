import 'package:clock_app/clock/data/favorite_cities.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:clock_app/clock/types/city.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  _SearchCityScreenState createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _filter = TextEditingController();

  List<City> _favoriteCities = [];
  List<City> _filteredCities = [];
  Database? _db;
  bool _isDatabaseLoaded = false;

  _SearchCityScreenState() {
    _filter.addListener(() async {
      setState(() {
        if (_isDatabaseLoaded) {
          if (_filter.text.isEmpty) {
            _filteredCities = [];
          } else {
            _db
                ?.rawQuery(
                    "SELECT * FROM Timezones WHERE City LIKE '%${_filter.text}%' LIMIT 10")
                .then((results) {
              _filteredCities = results
                  .map((result) => City(
                      result['City'] as String,
                      result['Country'] as String,
                      result['Timezone'] as String))
                  .toList();
            });
          }
        }
      });
    });
  }

  _loadDatabase() async {
    String databasePath = await getTimezonesDatabasePath();
    _db = await openDatabase(databasePath, readOnly: true);

    setState(() {
      _isDatabaseLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDatabase();
    setState(() {
      _favoriteCities = loadList('favorite_cities');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _filter,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for a city',
            hintStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: _filteredCities.length,
          itemBuilder: (BuildContext context, int index) {
            City city = _filteredCities[index];
            return TimeZoneSearchCard(
              city: city,
              disabled: _favoriteCities.any((favoriteCity) =>
                  favoriteCity.name == city.name &&
                  favoriteCity.country == city.country),
              onTap: () {
                Navigator.pop(context, city);
              },
            );
          },
        ),
      ),
    );
  }
}
