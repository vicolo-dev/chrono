import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/persistent_list_view.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/theme/shape.dart';
import 'package:flutter/material.dart';
import 'package:great_list_view/great_list_view.dart';

typedef AlarmCardBuilder = Widget Function(
  BuildContext context,
  int index,
  AnimatedWidgetBuilderData data,
);

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _listController = ListController<Alarm>();

  _handleEnableChangeAlarm(Alarm alarm, bool value) {
    int index = _listController.getItemIndex(alarm);
    _listController.changeItems((alarms) => alarms[index].setIsEnabled(value));
  }

  Future<Alarm?> _openCustomizeAlarmScreen(Alarm alarm) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeAlarmScreen(initialAlarm: alarm)),
    );
  }

  _handleCustomizeAlarm(Alarm alarm) async {
    int index = _listController.getItemIndex(alarm);
    Alarm? newAlarm = await _openCustomizeAlarmScreen(alarm);

    if (newAlarm == null) return;

    newAlarm.schedule();

    _listController.changeItems((alarms) => alarms[index] = newAlarm);

    _showNextScheduleSnackBar(newAlarm);
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Duration etaNextAlarm =
          alarm.nextScheduleDateTime.difference(DateTime.now().toLocal());

      int hours = etaNextAlarm.inHours;
      int minutes = etaNextAlarm.inMinutes % 60;

      String hourTextSuffix = hours <= 1 ? "hour" : "hours";
      String minuteTextSuffix = minutes % 60 <= 1 ? "minute" : "minutes";

      String hoursText = hours == 0 ? "" : "$hours $hourTextSuffix and ";
      String minutesText = minutes == 0
          ? "in less than 1 minute"
          : "$minutes $minuteTextSuffix from now";

      SnackBar snackBar = SnackBar(
        content: Container(
            alignment: Alignment.centerLeft,
            height: 28,
            child: Text('Alarm will ring $hoursText$minutesText')),
        margin: const EdgeInsets.only(left: 20, right: 64 + 16, bottom: 4),
        elevation: 2,
        dismissDirection: DismissDirection.none,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
        _listController.addItem(alarm);
      }
    }

    return Stack(
      children: [
        PersistentListView<Alarm>(
          saveTag: 'alarms',
          listController: _listController,
          itemBuilder: (alarm) => AlarmCard(
            alarm: alarm,
            onEnabledChange: (value) => _handleEnableChangeAlarm(alarm, value),
          ),
          onTapItem: (alarm, index) => _handleCustomizeAlarm(alarm),
          onAddItem: (alarm) {
            alarm.schedule();
            _showNextScheduleSnackBar(alarm);
          },
          onDeleteItem: (alarm) => setState(() {
            (alarm).disable();
          }),
          duplicateItem: (alarm) => Alarm.fromAlarm(alarm),
          placeholderText: "No alarms created",
          reloadOnPop: true,
        ),
        FAB(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            selectTime(_openCustomizeAlarmScreen);
          },
        )
      ],
    );
  }
}
