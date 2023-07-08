import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
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
  final _listController = PersistentListController<Alarm>();

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

    newAlarm.update();

    _listController.changeItems((alarms) => alarms[index] = newAlarm);

    _showNextScheduleSnackBar(newAlarm);
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      DateTime? nextScheduleDateTime = alarm.currentScheduleDateTime;
      if (nextScheduleDateTime == null) return;
      Duration etaNextAlarm =
          alarm.currentScheduleDateTime!.difference(DateTime.now().toLocal());

      String etaText = '';

      if (etaNextAlarm.inDays > 0) {
        int days = etaNextAlarm.inDays;
        String dayTextSuffix = days <= 1 ? 'day' : 'days';
        etaText = '$days $dayTextSuffix';
      } else if (etaNextAlarm.inHours > 0) {
        int hours = etaNextAlarm.inHours;
        int minutes = etaNextAlarm.inMinutes % 60;
        String hourTextSuffix = hours <= 1 ? 'hour' : 'hours';
        String minuteTextSuffix = minutes <= 1 ? 'minute' : 'minutes';
        String hoursText = '$hours $hourTextSuffix';
        String minutesText =
            minutes == 0 ? '' : ' and $minutes $minuteTextSuffix';
        etaText = '$hoursText$minutesText';
      } else if (etaNextAlarm.inMinutes > 0) {
        int minutes = etaNextAlarm.inMinutes;
        String minuteTextSuffix = minutes <= 1 ? 'minute' : 'minutes';
        etaText = '$minutes $minuteTextSuffix';
      } else {
        etaText = 'less than 1 minute';
      }

      SnackBar snackBar = SnackBar(
        content: Container(
          alignment: Alignment.centerLeft,
          height: 28,
          child: Text('Alarm will ring in $etaText'),
        ),
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
      final PickerResult<TimeOfDay>? timePickerResult =
          await showTimePickerDialog(
        context: context,
        initialTime: TimeOfDay.now(),
        title: "Select Time",
        cancelText: "Cancel",
        confirmText: "Save",
        useSimple: false,
      );

      if (timePickerResult != null) {
        Alarm alarm = Alarm(timePickerResult.value);
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
            onPressDelete: () => _listController.deleteItem(alarm),
          ),
          onTapItem: (alarm, index) => _handleCustomizeAlarm(alarm),
          onAddItem: (alarm) {
            alarm.update();
            _showNextScheduleSnackBar(alarm);
          },
          onDeleteItem: (alarm) => setState(() {
            alarm.disable();
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
