import 'package:clock_app/alarm/data/alarm_list_filters.dart';
import 'package:clock_app/alarm/data/alarm_sort_options.dart';
import 'package:clock_app/alarm/logic/new_alarm_snackbar.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/utils/next_alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/alarm/widgets/alarm_description.dart';
import 'package:clock_app/alarm/widgets/alarm_time_picker.dart';
import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/customize_list_item_screen.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Setting _showSort;
  late Setting _showNextAlarm;
  late Alarm? nextAlarm;

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
    final filtersGroup = appSettings.getGroup("Alarm").getGroup("Filters");
    _showFilters = filtersGroup.getSetting("Show Filters");
    _showSort = filtersGroup.getSetting("Show Sort");
    _showNextAlarm = filtersGroup.getSetting("Show Next Alarm");

    // appSettings.getGroup("Accessibility").getSetting("Left Handed Mode");

    _showInstantAlarmButton.addListener(update);
    _showFilters.addListener(update);
    _showNextAlarm.addListener(update);
    _showSort.addListener(update);

    // ListenerManager.addOnChangeListener("alarms", update);

    nextAlarm = getNextAlarm();

    // ListenerManager().addListener();
  }

  @override
  void dispose() {
    _showInstantAlarmButton.removeListener(update);
    _showFilters.removeListener(update);
    _showSort.removeListener(update);
    _showNextAlarm.removeListener(update);
    // ListenerManager.removeOnChangeListener("alarms", update);
    super.dispose();
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

  Future<void> _handleCustomizeAlarm(Alarm alarm) async {
    await _openCustomizeAlarmScreen(alarm, onSave: (newAlarm) async {
      // The alarm id changes for the new alarm, so we have to cancel the old one
      await alarm.cancel();
      alarm.copyFrom(newAlarm);
      await alarm
          .handleEdit("_handleCustomizeAlarm(): Alarm customized by the user");
      _listController.changeItems((alarms) {});
      _showNextScheduleSnackBar(newAlarm);
    });
  }

  void _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      DateTime? nextScheduleDateTime = alarm.currentScheduleDateTime;
      if (nextScheduleDateTime == null) return;
      ScaffoldMessenger.of(context).showSnackBar(getSnackbar(
          getNewAlarmText(context, alarm),
          fab: true,
          navBar: true));
    });
  }

  Future<void> _handleEnableChangeAlarm(Alarm alarm, bool value) async {
    if (!alarm.canBeDisabledWhenSnoozed && !value && alarm.isSnoozed) {
      showSnackBar(context,
          AppLocalizations.of(context)!.cannotDisableAlarmWhileSnoozedSnackbar,
          fab: true, navBar: true);
    } else {
      await alarm.setIsEnabled(value,
          "_handleEnableChangeAlarm(): Alarm enable set to $value by user");
      _listController.changeItems((alarms) {});
      _showNextScheduleSnackBar(alarm);
    }
  }

  Future<void> _handleEnableChangeMultiple(
      List<Alarm> alarms, bool value) async {
    for (var alarm in alarms) {
      if (!alarm.canBeDisabledWhenSnoozed && !value && alarm.isSnoozed) {
        showSnackBar(
            context,
            AppLocalizations.of(context)!
                .cannotDisableAlarmWhileSnoozedSnackbar,
            fab: true,
            navBar: true);
      } else {
        await alarm.setIsEnabled(value,
            "_handleEnableChangeMultipleAlarms(): Alarm enable set to $value by user");
        _showNextScheduleSnackBar(alarm);
      }
    }
    _listController.changeItems((alarms) {});
  }

  void _handleDeleteAlarm(Alarm alarm) {
    _listController.deleteItem(alarm);
  }

  void _handleSkipChange(Alarm alarm, bool value) {
    alarm.setShouldSkip(value);
    _listController.changeItems((alarms) {});
  }

  void _handleSkipChangeMultiple(List<Alarm> alarms, bool value) {
    for (var alarm in alarms) {
      alarm.setShouldSkip(value);
    }
    _listController.changeItems((alarms) {});
  }

  Future<void> _handleDismissAlarm(Alarm alarm) async {
    await alarm.cancelSnooze();
    await alarm.update("_handleDismissAlarm(): Alarm dismissed by user");
    _listController.changeItems((alarms) {});
  }

  List<ListFilterItem<Alarm>> getListFilterItems() {
    List<ListFilterItem<Alarm>> listFilterItems =
        _showFilters.value ? [...alarmListFilters] : [];

    if (nextAlarm != null && _showNextAlarm.value) {
      if (nextAlarm!.currentScheduleDateTime != null) {
        listFilterItems.insert(
            0,
            ListFilter<Alarm>(
              (context) => getNextAlarmText(context, nextAlarm!),
              (alarm) => alarm.id == nextAlarm!.id,
            ));
      }
    }

    return listFilterItems;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> selectTime() async {
      final PickerResult<TimeOfDay>? timePickerResult =
          await showTimePickerDialog(
        context: context,
        initialTime: TimeOfDay.now(),
        title: AppLocalizations.of(context)!.selectTime,
        cancelText: AppLocalizations.of(context)!.cancelButton,
        confirmText: AppLocalizations.of(context)!.saveButton,
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
          placeholderText: AppLocalizations.of(context)!.noAlarmMessage,
          reloadOnPop: true,
          onSaveItems: (items) {
            nextAlarm = getNextAlarm();
            setState(() {});
          },
          isSelectable: true,
          // header: getNextAlarmWidget(),
          listFilters: getListFilterItems(),
          customActions: _showFilters.value
              ? [
                  ListFilterCustomAction(
                      name: AppLocalizations.of(context)!
                          .enableAllFilteredAlarmsAction,
                      icon: Icons.alarm_on_rounded,
                      action: (alarms) {
                        _handleEnableChangeMultiple(alarms, true);
                      }),
                  ListFilterCustomAction(
                      name: AppLocalizations.of(context)!
                          .disableAllFilteredAlarmsAction,
                      icon: Icons.alarm_off_rounded,
                      action: (alarms) {
                        _handleEnableChangeMultiple(alarms, false);
                      }),
                  ListFilterCustomAction(
                      name: AppLocalizations.of(context)!
                          .skipAllFilteredAlarmsAction,
                      icon: Icons.skip_next_rounded,
                      action: (alarms) {
                        _handleSkipChangeMultiple(alarms, true);
                      }),
                  ListFilterCustomAction(
                      name: AppLocalizations.of(context)!
                          .cancelSkipAllFilteredAlarmsAction,
                      icon: Icons.skip_next_rounded,
                      action: (alarms) {
                        _handleSkipChangeMultiple(alarms, false);
                      }),
                ]
              : [],
          sortOptions: _showSort.value ? alarmSortOptions : [],
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
