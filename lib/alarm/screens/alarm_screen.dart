import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list_footer.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/theme/shape.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> _alarms = [];

  void loadAlarms() {
    setState(() {
      _alarms = loadList('alarms');
    });
  }

  @override
  void initState() {
    super.initState();
    SettingsManager.addOnChangeListener("alarms", loadAlarms);
    loadAlarms();
  }

  @override
  void dispose() {
    SettingsManager.removeOnChangeListener("alarms");
    super.dispose();
  }

  _handleReorderAlarms(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Alarm reorderedAlarm = _alarms.removeAt(oldIndex);
      _alarms.insert(newIndex, reorderedAlarm);
    });
    saveList('alarms', _alarms);
  }

  _handleDeleteAlarm(int index) {
    _alarms[index].disable();
    setState(() {
      _alarms.removeAt(index);
    });

    saveList('alarms', _alarms);
  }

  _handleEnableChangeAlarm(int index, bool value) {
    setState(() {
      _alarms[index].setIsEnabled(value);
    });
    saveList('alarms', _alarms);
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Duration etaNextAlarm =
          alarm.nextScheduleDateTime.difference(DateTime.now().toLocal());

      int hours = etaNextAlarm.inHours;
      int minutes = etaNextAlarm.inMinutes % 60;

      minutes = minutes == 0 ? 1 : minutes;

      String hourTextSuffix = hours <= 1 ? "hour" : "hours";
      String minuteTextSuffix = minutes % 60 <= 1 ? "minute" : "minutes";

      String hoursText = hours == 0 ? "" : "$hours $hourTextSuffix and ";
      String minutesText = "$minutes $minuteTextSuffix";

      SnackBar snackBar = SnackBar(
        content: Text('Alarm will ring in $hoursText$minutesText'),
        margin: const EdgeInsets.only(left: 20, right: 64 + 16, bottom: 4),
        shape: defaultShape,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _handleAddAlarm(Alarm alarm) {
    alarm.schedule();
    setState(() {
      _alarms.add(alarm);
    });

    _showNextScheduleSnackBar(alarm);

    saveList('alarms', _alarms);
  }

  Future<Alarm?> _openCustomizeAlarmScreen(Alarm alarm) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeAlarmScreen(initialAlarm: alarm)),
    );
  }

  _handleCustomizeAlarm(int index) async {
    Alarm? newAlarm = await _openCustomizeAlarmScreen(_alarms[index]);

    if (newAlarm == null) return;

    newAlarm.schedule();
    setState(() {
      _alarms[index] = newAlarm;
    });

    _showNextScheduleSnackBar(newAlarm);

    saveList('alarms', _alarms);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectTime(Future<Alarm?> Function(Alarm) onCustomize) async {
      final TimePickerResult? timePickerResult = await showTimePickerDialog(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: "Select Time",
        cancelText: "Cancel",
        confirmText: "Save",
        useSimple: false,
      );

      if (timePickerResult != null) {
        Alarm alarm = Alarm(timePickerResult.timeOfDay);
        if (timePickerResult.isCustomize) {
          alarm = await onCustomize(alarm) ?? alarm;
        }

        _handleAddAlarm(alarm);
      }
    }

    return Stack(
      children: [
        ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          proxyDecorator: reorderableListDecorator,
          itemCount: _alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return AlarmCard(
              key: ValueKey(_alarms[index]),
              alarm: _alarms[index],
              onTap: () => _handleCustomizeAlarm(index),
              onDelete: () => _handleDeleteAlarm(index),
              onEnabledChange: (bool value) =>
                  _handleEnableChangeAlarm(index, value),
            );
          },
          footer:
              const ListFooter(), // Allows the last item to not be covered by FAB
          onReorder: _handleReorderAlarms,
        ),
        FAB(
          onPressed: () => selectTime(_openCustomizeAlarmScreen),
        )
      ],
    );
  }
}
