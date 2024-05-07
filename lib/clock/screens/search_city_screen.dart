import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:clock_app/clock/types/city.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _filterController = TextEditingController();

  List<City> _favoriteCities = [];
  List<City> _filteredCities = [];
  Database? _db;
  bool _isDatabaseLoaded = false;

  _SearchCityScreenState() {
    _filterController.addListener(() async {
      if (_isDatabaseLoaded) {
        if (_filterController.text.isEmpty) {
          setState(() => _filteredCities = []);
        } else {
          if (_db == null) return;
          String query =
              "SELECT * FROM Timezones WHERE City || Country LIKE '%${_filterController.text}%' LIMIT 10";
          final results = await _db!.rawQuery(query);
          setState(() {
            _filteredCities = results
                .map((result) => City(
                      result['City'] as String,
                      result['Country'] as String,
                      result['Timezone'] as String,
                    ))
                .toList();
          });
        }
      }
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
      _favoriteCities = loadListSync('favorite_cities');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: TextField(
          autofocus: true,
          controller: _filterController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            fillColor: Colors.transparent,
            hintText: AppLocalizations.of(context)!.searchCityPlaceholder,
            hintStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: _filteredCities
              .map((city) => TimeZoneSearchCard(
                    city: city,
                    disabled: _favoriteCities.any((favoriteCity) =>
                        favoriteCity.name == city.name &&
                        favoriteCity.country == city.country),
                    onTap: () {
                      Navigator.pop(context, city);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
