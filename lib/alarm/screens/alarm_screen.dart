import 'package:clock_app/alarm/data/alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list_footer.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> _alarms = [];

  @override
  void initState() {
    super.initState();
    setState(() => _alarms = loadAlarms());
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePickerDialog(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select Time",
      cancelText: "Cancel",
      confirmText: "Save",
      // dialogActions: [
      //   DialogAction(
      //     onPressed: () => {},
      //     label: "Customize",
      //   ),
      // ],
    );

    if (pickedTime != null) {
      Alarm alarm = Alarm(pickedTime);
      setState(() {
        _alarms.add(alarm);
      });

      setAlarms(_alarms);
    }
  }

  _onReorderAlarms(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Alarm reorderedAlarm = _alarms.removeAt(oldIndex);
      _alarms.insert(newIndex, reorderedAlarm);
    });
    setAlarms(_alarms);
  }

  _onDeleteAlarm(int index) {
    _alarms[index].disable();
    setState(() {
      _alarms.removeAt(index);
    });

    setAlarms(_alarms);
  }

  _onEnableChangeAlarm(int index, bool value) {
    setState(() {
      _alarms[index].setIsEnabled(value);
    });
    setAlarms(_alarms);
  }

  @override
  Widget build(BuildContext context) {
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
              onDelete: () => _onDeleteAlarm(index),
              onEnabledChange: (bool value) =>
                  _onEnableChangeAlarm(index, value),
            );
          },
          footer:
              const ListFooter(), // Allows the last item to not be covered by FAB
          onReorder: _onReorderAlarms,
        ),
        FAB(
          onPressed: () {
            // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
            //   if (!isAllowed) {
            //     // This is just a basic example. For real apps, you must show some
            //     // friendly dialog box before call the request method.
            //     // This is very important to not harm the user experience
            //     AwesomeNotifications().requestPermissionToSendNotifications();
            //   }
            // });

            _selectTime(context);
          },
        )
      ],
    );
  }
}
