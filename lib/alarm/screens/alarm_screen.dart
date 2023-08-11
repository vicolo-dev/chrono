import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
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
  late Setting showInstantAlarmButton;

  final List<ListFilter<Alarm>> _listFilters = [
    ListFilter(
      'All',
      (alarm) => true,
    ),
    ListFilter(
      'Today',
      (alarm) {
        if (alarm.currentScheduleDateTime == null) return false;
        return alarm.currentScheduleDateTime!.isToday();
      },
    ),
    ListFilter('Tomorrow', (alarm) {
      if (alarm.currentScheduleDateTime == null) return false;
      return alarm.currentScheduleDateTime!.isTomorrow();
    }),
    ListFilter(
      'Completed',
      (alarm) => alarm.isFinished,
    ),
    ListFilter(
      'Disabled',
      (alarm) => !alarm.isEnabled,
    ),
  ];

  void update(value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    showInstantAlarmButton = appSettings
        .getGroup("Developer Options")
        .getSetting("Show Instant Alarm Button");

    showInstantAlarmButton.addListener(update);
  }

  @override
  void dispose() {
    showInstantAlarmButton.removeListener(update);
    super.dispose();
  }

  _handleEnableChangeAlarm(Alarm alarm, bool value) {
    int index = _listController.getItemIndex(alarm);
    _listController.changeItems((alarms) => alarms[index].setIsEnabled(value));
  }

  Future<Alarm?> _openCustomizeAlarmScreen(
    Alarm alarm, {
    void Function(Alarm)? onSave,
    bool isNewAlarm = false,
  }) async {
    return openCustomizeScreen(
      context,
      CustomizeAlarmScreen(alarm: alarm, isNewAlarm: isNewAlarm),
      onSave: onSave,
    );
  }

  _handleCustomizeAlarm(Alarm alarm) async {
    int index = _listController.getItemIndex(alarm);
    await _openCustomizeAlarmScreen(alarm, onSave: (newAlarm) {
      newAlarm.update();
      _listController.changeItems((alarms) => alarms[index] = newAlarm);
      _showNextScheduleSnackBar(newAlarm);
    });
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
    Future<void> selectTime() async {
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
        Alarm alarm = Alarm.fromTimeOfDay(timePickerResult.value);
        if (timePickerResult.isCustomize) {
          await _openCustomizeAlarmScreen(alarm, onSave: (newAlarm) {
            _listController.addItem(newAlarm);
          }, isNewAlarm: true);
        } else {
          _listController.addItem(alarm);
        }
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
            onPressDuplicate: () => _listController.duplicateItem(alarm),
          ),
          onTapItem: (alarm, index) => _handleCustomizeAlarm(alarm),
          onAddItem: (alarm) {
            alarm.update();
            _showNextScheduleSnackBar(alarm);
          },
          onDeleteItem: (alarm) => setState(() {
            alarm.disable();
          }),
          placeholderText: "No alarms created",
          reloadOnPop: true,
          listFilters: _listFilters,
        ),
        FAB(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            selectTime();
          },
        ),
        if (showInstantAlarmButton.value)
          FAB(
            onPressed: () {
              Alarm alarm = Alarm(Time.fromNow(const Duration(seconds: 5)));
              _listController.addItem(alarm);
            },
            index: 1,
            icon: Icons.alarm,
          )
      ],
    );
  }
}
