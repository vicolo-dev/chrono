import 'package:clock_app/clock/screens/search_city_screen.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/common/widgets/clock/analog_clock/analog_clock.dart';
import 'package:clock_app/common/widgets/clock/digital_clock.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Setting showSecondsSetting;
  late Setting clockTypeSetting;
  late Setting clockNumberTypeSetting;
  late Setting clockNumeralTypeSetting;
  late Setting clockTicksTypeSetting;
  late Setting showDigitalClockSetting;

  final _listController = PersistentListController<City>();

  void update(dynamic) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    showSecondsSetting = appSettings
        .getGroup("General")
        .getGroup("Display")
        .getSetting("Show Seconds");
    SettingGroup clockStyleSettingGroup =
        appSettings.getGroup("clock").getGroup("clockStyle");

    clockTypeSetting = clockStyleSettingGroup.getSetting("clockType");
    clockNumberTypeSetting = clockStyleSettingGroup.getSetting("showNumbers");
    clockNumeralTypeSetting = clockStyleSettingGroup.getSetting("numeralType");
    clockTicksTypeSetting = clockStyleSettingGroup.getSetting("showTicks");
    showDigitalClockSetting =
        clockStyleSettingGroup.getSetting("showDigitalClock");

    showSecondsSetting.addListener(update);
    clockTypeSetting.addListener(update);
    clockNumberTypeSetting.addListener(update);
    clockNumeralTypeSetting.addListener(update);
    clockTicksTypeSetting.addListener(update);
    showDigitalClockSetting.addListener(update);
  }

  @override
  void dispose() {
    showSecondsSetting.removeListener(update);
    clockTypeSetting.removeListener(update);
    clockNumberTypeSetting.removeListener(update);
    clockNumeralTypeSetting.removeListener(update);
    clockTicksTypeSetting.removeListener(update);
    showDigitalClockSetting.removeListener(update);
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
          child: clockTypeSetting.value == ClockType.analog
              ? AnalogClock(
                  showDigitalClock: showDigitalClockSetting.value,
                  showSeconds: showSecondsSetting.value,
                  numbersType: clockNumberTypeSetting.value,
                  numeralType: clockNumeralTypeSetting.value,
                  ticksType: clockTicksTypeSetting.value,
                )
              : DigitalClock(
                  shouldShowDate: true,
                  shouldShowSeconds: showSecondsSetting.value,
                  horizontalAlignment: ElementAlignment.center,
                ),
        ),
        // const SizedBox(height: 8),
        Expanded(
          child: PersistentListView<City>(
            saveTag: 'favorite_cities',
            listController: _listController,
            itemBuilder: (city) => TimeZoneCard(
                city: city, onDelete: () => _listController.deleteItem(city)),
            placeholderText: "No cities added",
            isDuplicateEnabled: false,
            isSelectable: true,
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
