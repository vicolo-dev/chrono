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
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    SettingsManager.removeOnChangeListener("alarms");
    super.dispose();
  }

  @override
  void didPush() async {
    print("didPush");
    loadAlarms();

    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() async {
    print("didPopNext");
    loadAlarms();
    // Covering route was popped off the navigator.
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

  _handleCustomizeAlarm(int index) async {
    Alarm? newAlarm = await _openCustomizeAlarmScreen(_alarms[index]);

    if (newAlarm == null) return;

    newAlarm.schedule();
    setState(() {
      _alarms[index] = newAlarm;
    });

    saveList('alarms', _alarms);
  }

  Future<Alarm?> _openCustomizeAlarmScreen(Alarm alarm) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeAlarmScreen(initialAlarm: alarm)),
    );
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
