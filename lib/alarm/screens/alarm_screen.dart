import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list_footer.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> _alarms = [];

  @override
  void initState() {
    super.initState();
    setState(() => _alarms = loadList('alarms'));
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

  _handleAddAlarm(Alarm alarm) {
    alarm.schedule();
    setState(() {
      _alarms.add(alarm);
    });

    saveList('alarms', _alarms);
  }

  _handleCustomizeAlarm(int index) {
    Alarm? newAlarm = _openCustomizeAlarmScreen(_alarms[index]);

    if (newAlarm == null) return;

    setState(() {
      _alarms[index] = newAlarm;
    });

    saveList('alarms', _alarms);
  }

  Alarm? _openCustomizeAlarmScreen(Alarm alarm) {
    Alarm? newAlarm;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeAlarmScreen(initialAlarm: alarm)),
    ).then(
      (dynamic value) {
        if (value != null) {
          newAlarm = value as Alarm;
        }
      },
    );

    return newAlarm;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectTime(void Function(Alarm) onCustomize) async {
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
          onCustomize(alarm);
        } else {
          _handleAddAlarm(alarm);
        }
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
          onPressed: () => selectTime(
            (Alarm alarm) {
              Alarm? newAlarm = _openCustomizeAlarmScreen(alarm);
              if (newAlarm != null) _handleAddAlarm(newAlarm);
            },
          ),
        )
      ],
    );
  }
}
