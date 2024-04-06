import 'package:clock_app/alarm/data/alarm_list_filters.dart';
import 'package:clock_app/alarm/logic/new_alarm_snackbar.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/alarm/widgets/alarm_description.dart';
import 'package:clock_app/alarm/widgets/alarm_time_picker.dart';
import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/customize_list_item_screen.dart';
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
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _listController = PersistentListController<Alarm>();
  late Setting _showInstantAlarmButton;
  late Setting _showFilters;

  void update(value) {
    setState(() {});
    _listController.changeItems((alarms) => {});
  }

  @override
  void initState() {
    super.initState();

    _showInstantAlarmButton = appSettings
        .getGroup("Developer Options")
        .getSetting("Show Instant Alarm Button");
    _showFilters = appSettings.getGroup("Alarm").getSetting("Show Filters");
    appSettings.getGroup("Accessibility").getSetting("Left Handed Mode");

    _showInstantAlarmButton.addListener(update);
    _showFilters.addListener(update);

    // ListenerManager().addListener();
  }

  @override
  void dispose() {
    _showInstantAlarmButton.removeListener(update);
    _showFilters.removeListener(update);
    super.dispose();
  }

  _handleEnableChangeAlarm(Alarm alarm, bool value) {
    if (!alarm.canBeDisabledWhenSnoozed && !value && alarm.isSnoozed) {
      showSnackBar(context, "Cannot disable alarm while it is snoozed",
          fab: true, navBar: true);
    } else {
      int index = _listController.getItemIndex(alarm);
      _listController.changeItems((alarms) async {
        await alarms[index].setIsEnabled(value,
            "_handleEnableChangeAlarm(): Alarm enable set to $value by user");
        _showNextScheduleSnackBar(alarms[index]);
      });
    }
  }

  Future<Alarm?> _openCustomizeAlarmScreen(
    Alarm alarm, {
    Future<void> Function(Alarm)? onSave,
    bool isNewAlarm = false,
  }) async {
    return openCustomizeScreen(
      context,
      CustomizeListItemScreen(
        item: alarm,
        isNewItem: isNewAlarm,
        headerBuilder: (alarmItem) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              AlarmTimePicker(alarm: alarmItem),
              AlarmDescription(alarm: alarmItem),
            ],
          ),
        ),
      ),
      onSave: onSave,
    );
  }

  _handleCustomizeAlarm(Alarm alarm) async {
    int index = _listController.getItemIndex(alarm);
    // if (index < 0) return;
    await _openCustomizeAlarmScreen(alarm, onSave: (newAlarm) async {
      await newAlarm
          .update("_handleCustomizeAlarm(): Alarm customized by the user");
      _listController.changeItems((alarms) async {
        alarms[index] = newAlarm;
      });
      _showNextScheduleSnackBar(newAlarm);
    });
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      DateTime? nextScheduleDateTime = alarm.currentScheduleDateTime;
      if (nextScheduleDateTime == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackbar(getNewAlarmSnackbarText(alarm), fab: true, navBar: true));
    });
  }

  _handleDeleteAlarm(Alarm alarm) {
    _listController.deleteItem(alarm);
  }

  _handleSkipChange(Alarm alarm, bool value) {
    int index = _listController.getItemIndex(alarm);
    _listController.changeItems((alarms) async {
      alarms[index].setShouldSkip(value);
    });
  }

  _handleDismissAlarm(Alarm alarm) {
    int index = _listController.getItemIndex(alarm);
    _listController.changeItems((alarms) async {
      await alarms[index].cancelSnooze();
      await alarms[index]
          .update("_handleDismissAlarm(): Alarm dismissed by user");
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
          await _openCustomizeAlarmScreen(alarm, onSave: (newAlarm) async {
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
            onPressDelete: () => _handleDeleteAlarm(alarm),
            onPressDuplicate: () => _listController.duplicateItem(alarm),
            onDismiss: () => _handleDismissAlarm(alarm),
            onSkipChange: (value) => _handleSkipChange(alarm, value),
          ),
          onTapItem: (alarm, index) => _handleCustomizeAlarm(alarm),
          onAddItem: (alarm) async {
            await alarm.update("onAddItem(): Alarm added by user");
            _showNextScheduleSnackBar(alarm);
          },
          onDeleteItem: (alarm) async {
            await alarm.disable();
          },
          placeholderText: "No alarms created",
          reloadOnPop: true,
          listFilters: _showFilters.value ? alarmListFilters : [],
          customActions: [
            ListFilterCustomAction(
                name: "Enable all filtered alarms",
                icon: Icons.alarm_on_rounded,
                action: (alarms)async {
                  for(var alarm in alarms){
                  await _handleEnableChangeAlarm(alarm, true);
                  }
                }),
            ListFilterCustomAction(
                name: "Disable all filtered alarms",
                icon: Icons.alarm_off_rounded,
                action: (alarms) async{
                  for(var alarm in alarms){
                  await _handleEnableChangeAlarm(alarm, false);
                  }
                }),
          ],
          sortOptions: [
            ListSortOption<Alarm>("Date Descending", "9-1", (a, b) {
              if (a.currentScheduleDateTime == null &&
                  b.currentScheduleDateTime == null) {
                return 0;
              } else if (a.currentScheduleDateTime == null) {
                return 1;
              } else if (b.currentScheduleDateTime == null) {
                return -1;
              }
              return b.currentScheduleDateTime!
                  .compareTo(a.currentScheduleDateTime!);
            }),
            ListSortOption<Alarm>("Date Ascending", "1-9", (a, b) {
              if (a.currentScheduleDateTime == null &&
                  b.currentScheduleDateTime == null) {
                return 0;
              } else if (a.currentScheduleDateTime == null) {
                return 1;
              } else if (b.currentScheduleDateTime == null) {
                return -1;
              }
              return a.currentScheduleDateTime!
                  .compareTo(b.currentScheduleDateTime!);
            }),
          ],
        ),
        FAB(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            selectTime();
          },
        ),
        if (_showInstantAlarmButton.value)
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
