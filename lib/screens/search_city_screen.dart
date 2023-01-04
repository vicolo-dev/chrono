import 'package:clock_app/widgets/timezone_search_card.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:clock_app/types/city.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key, required this.existingCities});

  final List<City> existingCities;

  @override
  _SearchCityScreenState createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _filter = TextEditingController();
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
                  .where((result) => !widget.existingCities
                      .any((city) => city.name == result.name))
                  .toList();
            });
          }
        }
      });
    });
  }

  _loadDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = path.join(appDocDir.path, 'timezones.db');
    _db = await openDatabase(databasePath);
    setState(() {
      _isDatabaseLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _filter,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for a city',
          ),
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
