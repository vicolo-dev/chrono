import 'dart:io';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:timezone/data/latest.dart' as timezone_db;
import 'package:timezone/timezone.dart' as timezone;
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class City {
  final String name;
  final String country;
  final String timeZone;

  City(this.name, this.country, this.timeZone);
}

String formatTimeOffset(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

Future<void> initializeDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String databasePath = path.join(documentsDirectory.path, "timezones.db");

// Only copy if the database doesn't exist
  if (FileSystemEntity.typeSync(databasePath) ==
      FileSystemEntityType.notFound) {
    // Load database from asset and copy
    ByteData data = await rootBundle.load(path.join('assets', 'timezones.db'));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await File(databasePath).writeAsBytes(bytes);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone_db.initializeTimeZones();
  await initializeDatabase();
  runApp(const MyApp());
}

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
          print("Searching for ${_filter.text}");
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
            return SearchTimeZoneCard(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.grey[300],
        fontFamily: 'Poppins',
      ),
      home: const ClockScreen(title: 'Clock'),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key, required this.title});

  final String title;

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  int _selectedIndex = 0;

  final List<City> _cities = <City>[];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
          Icons.add,
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

class SearchTimeZoneCard extends StatelessWidget {
  SearchTimeZoneCard({
    Key? key,
    required this.city,
    required this.onTap,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timeZone);
  }

  late final timezone.Location timezoneLocation;
  final City city;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        city.country,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TimeZoneClock(
                      timezoneLocation: timezoneLocation, fontSize: 22),
                ],
              ),
            ),
            onTap: () => onTap(),
          )),
    );
  }
}

class TimeZoneCard extends StatelessWidget {
  TimeZoneCard({
    Key? key,
    required this.city,
    required this.onDelete,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timeZone);
    // get current user timezone
    offset = (timezoneLocation.currentTimeZone.offset -
            DateTime.now().timeZoneOffset.inMilliseconds) /
        3600000;
  }

  late final timezone.Location timezoneLocation;
  late final double offset;
  final City city;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (context) => onDelete(),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onDelete(),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      offset != 0
                          ? ' ${formatTimeOffset(offset.abs())} ${offset == 1 ? 'hour' : 'hours'} ${offset < 0 ? 'behind' : 'ahead'}'
                          : 'Same time',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TimeZoneClock(timezoneLocation: timezoneLocation, fontSize: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeZoneClock extends StatelessWidget {
  const TimeZoneClock({
    Key? key,
    required this.timezoneLocation,
    required this.fontSize,
  }) : super(key: key);

  final timezone.Location timezoneLocation;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        var date = timezone.TZDateTime.now(timezoneLocation);
        String formattedTime = DateFormat('kk:mm').format(date);
        return Text(
          formattedTime,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

class MainClock extends StatelessWidget {
  const MainClock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d').format(now);
    String meridiem = DateFormat('a').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            // eliminate padding between children
            children: [
              TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  DateTime now = DateTime.now();
                  String formattedTime = DateFormat('h:mm').format(now);
                  return Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      height: 0.75,
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              Text(
                meridiem,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ]),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
