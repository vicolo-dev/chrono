import 'package:clock_app/clock/screens/search_city_screen.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/widgets/clock.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/persistent_list_view.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  bool shouldShowSeconds = false;

  final _listController = ListController<City>();

  void setShowSeconds(dynamic value) {
    setState(() {
      shouldShowSeconds = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setShowSeconds(appSettings.getSetting("Show Seconds").value);
    appSettings.addSettingListener("Show Seconds", setShowSeconds);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener("Show Seconds", setShowSeconds);
    super.dispose();
  }

  void _handleSearchReturn(dynamic city) {
    if (city != null) {
      _listController.addItem(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Clock(
            shouldShowDate: true,
            shouldShowSeconds: shouldShowSeconds,
            horizontalAlignment: ElementAlignment.center,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PersistentListView<City>(
            saveTag: 'favorite_cities',
            listController: _listController,
            itemBuilder: (city) => TimeZoneCard(city: city),
            placeholderText: "No cities added",
            isDuplicateEnabled: false,
          ),
        ),
      ]),
      FAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCityScreen()),
          ).then(_handleSearchReturn);
        },
      )
    ]);
  }
}
