import 'package:clock_app/alarm/screens/customize_alarm_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/widgets/alarm_card.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/theme/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class _AlarmScreenState extends State<AlarmScreen> with RouteAware {
  List<Alarm> _alarms = [];

  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  int _getAlarmIndex(Alarm alarm) => _alarms.indexWhere(
      (element) => element.currentScheduleId == alarm.currentScheduleId);

  void loadAlarms() {
    setState(() {
      _alarms = loadList('alarms');
    });

    _controller.notifyChangedRange(
      0,
      _alarms.length,
      getChangeWidgetBuilder(),
    );
  }

  @override
  void initState() {
    super.initState();
    _alarms = loadList('alarms');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    loadAlarms();
  }

  bool _handleReorderAlarms(int oldIndex, int newIndex, Object? slot) {
    _alarms.insert(newIndex, _alarms.removeAt(oldIndex));
    saveList('alarms', _alarms);
    return true;
  }

  AlarmCardBuilder getAlarmChangeWidgetBuilder(Alarm alarm) =>
      (context, index, data) => data.measuring
          ? const SizedBox(width: 64, height: 64)
          : AlarmCard(
              key: ValueKey(alarm),
              alarm: alarm,
              onTap: () => {},
              onDelete: () => {},
              onDuplicate: () => {},
              onEnabledChange: (value) => {},
            );

  AlarmCardBuilder getChangeWidgetBuilder() => (context, index, data) =>
      getAlarmChangeWidgetBuilder(_alarms[index])(context, index, data);

  _handleDeleteAlarm(Alarm deletedAlarm) {
    int index = _getAlarmIndex(deletedAlarm);
    _alarms[index].disable();
    _alarms.removeAt(index);
    _controller.notifyRemovedRange(
      index,
      1,
      getAlarmChangeWidgetBuilder(deletedAlarm),
    );
    saveList('alarms', _alarms);
  }

  _handleEnableChangeAlarm(Alarm alarm, bool value) {
    int index = _getAlarmIndex(alarm);
    _alarms[index].setIsEnabled(value);

    _controller.notifyChangedRange(
      index,
      1,
      getAlarmChangeWidgetBuilder(alarm),
    );
    saveList('alarms', _alarms);
  }

  _handleAddAlarm(Alarm alarm, {int index = -1}) {
    if (index == -1) index = _alarms.length;
    alarm.schedule();
    _alarms.insert(index, alarm);
    _controller.notifyInsertedRange(index, 1);

    _showNextScheduleSnackBar(alarm);

    saveList('alarms', _alarms);
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
    int index = _getAlarmIndex(alarm);
    Alarm? newAlarm = await _openCustomizeAlarmScreen(alarm);

    if (newAlarm == null) return;

    newAlarm.schedule();
    _alarms[index] = newAlarm;
    _controller.notifyChangedRange(
      index,
      1,
      getAlarmChangeWidgetBuilder(alarm),
    );

    _showNextScheduleSnackBar(newAlarm);

    saveList('alarms', _alarms);
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
        content: Text('Alarm will ring $hoursText$minutesText'),
        margin: const EdgeInsets.only(left: 20, right: 64 + 16, bottom: 4),
        shape: defaultShape,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        dismissDirection: DismissDirection.none,
        // width: MediaQuery.of(context).size.width - (64 + 16),
        // behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.75;

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
        SlidableAutoCloseBehavior(
          child: AutomaticAnimatedListView<Alarm>(
            list: _alarms,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            comparator: AnimatedListDiffListComparator<Alarm>(
              sameItem: (a, b) => a.currentScheduleId == b.currentScheduleId,
              sameContent: (a, b) => a.currentScheduleId == b.currentScheduleId,
            ),
            itemBuilder: (BuildContext context, Alarm alarm, data) {
              return data.measuring
                  ? const SizedBox(width: 64, height: 64)
                  : AlarmCard(
                      key: ValueKey(alarm),
                      alarm: alarm,
                      onTap: () => _handleCustomizeAlarm(alarm),
                      onDelete: () => _handleDeleteAlarm(alarm),
                      onDuplicate: () => _handleAddAlarm(Alarm.fromAlarm(alarm),
                          index: _getAlarmIndex(alarm) + 1),
                      onEnabledChange: (bool value) =>
                          _handleEnableChangeAlarm(alarm, value),
                    );
            },
            // animator: DefaultAnimatedListAnimator,
            listController: _controller,
            scrollController: _scrollController,
            addLongPressReorderable: true,
            reorderModel: AnimatedListReorderModel(
              onReorderStart: (index, dx, dy) => true,
              onReorderFeedback: (int index, int dropIndex, double offset,
                      double dx, double dy) =>
                  null,
              onReorderMove: (int index, int dropIndex) => true,
              onReorderComplete: _handleReorderAlarms,
            ),
            reorderDecorationBuilder: reorderableListDecorator,
            footer: const SizedBox(height: 64),
          ),
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
