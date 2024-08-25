import 'dart:async';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/list/customize_list_item_screen.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/data/update_notification_intervals.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/timer/data/timer_list_filters.dart';
import 'package:clock_app/timer/data/timer_sort_options.dart';
import 'package:clock_app/timer/logic/timer_notification.dart';
import 'package:clock_app/timer/screens/timer_fullscreen.dart';
import 'package:clock_app/timer/widgets/timer_duration_picker.dart';
import 'package:clock_app/timer/widgets/timer_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/timer_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Future<bool> updateForegroundTask(List<ClockTimer> timers) async {
//   final runningTimers = timers.where((timer) => !timer.isStopped).toList();
//   if (runningTimers.isEmpty) {
//     FlutterForegroundTask.stopService();
//     // timerNotificationInterval?.cancel();
//     return false;
//   }
//   // Get timer with lowest remaining time
//   final timer = runningTimers
//       .reduce((a, b) => a.remainingSeconds < b.remainingSeconds ? a : b);
//   final count = runningTimers.length;
//
//   if (await FlutterForegroundTask.isRunningService) {
//     return FlutterForegroundTask.updateService(
//       notificationTitle:
//           "${timer.label.isEmpty ? 'Timer' : timer.label}${count > 1 ? ' + ${count - 1} timers' : ''}",
//       notificationText:
//           TimeDuration.fromSeconds(timer.remainingSeconds).toTimeString(),
//       callback: startCallback,
//     );
//   } else {
//     return FlutterForegroundTask.startService(
//       notificationTitle:
//           "${timer.label.isEmpty ? 'Timer' : timer.label}${count > 1 ? ' + ${count - 1} timers' : ''}",
//       notificationText:
//           TimeDuration.fromSeconds(timer.remainingSeconds).toTimeString(),
//       callback: startCallback,
//     );
//   }
// }
//
// // The callback function should always be a top-level function.
// @pragma('vm:entry-point')
// void startCallback() async {
//   await initializeIsolate();
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
// }
//
// class FirstTaskHandler extends TaskHandler {
//   // SendPort? _sendPort;
//
//   // Called when the task is started.
//   @override
//   void onStart(DateTime timestamp, SendPort? sendPort) async {}
//
//   // Called every [interval] milliseconds in [ForegroundTaskOptions].
//   @override
//   void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
//     // Send data to the main isolate.
//     // sendPort?.send(timestamp);
//     final timers = await loadList<ClockTimer>('timers');
//     updateForegroundTask(timers);
//   }
//
//   // Called when the notification button on the Android platform is pressed.
//   @override
//   void onDestroy(DateTime timestamp, SendPort? sendPort) async {}
//
//   // Called when the notification button on the Android platform is pressed.
//   @override
//   void onNotificationButtonPressed(String id) {
//     // print('onNotificationButtonPressed >> $id');
//   }
//
//   // Called when the notification itself on the Android platform is pressed.
//   //
//   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//   // this function to be called.
//   @override
//   void onNotificationPressed() {
//     // Note that the app will only route to "/resume-route" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("/");
//     // _sendPort?.send('onNotificationPressed');
//   }
// }

typedef TimerCardBuilder = Widget Function(
  BuildContext context,
  int index,
  AnimatedWidgetBuilderData data,
);

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _listController = PersistentListController<ClockTimer>();
  late Setting _showFilters;
  late Setting _showSort;
  late Setting _showNotification;
  ReceivePort? _receivePort;

  void update(value) {
    setState(() {});
    _listController.changeItems((timers) => {});
  }

  void _updateTimerNotification() {
    // updateForegroundTask(_listController.getItems());
    if (!_showNotification.value) {
      AwesomeNotifications()
          .cancelNotificationsByChannelKey(timerNotificationChannelKey);
      timerNotificationInterval?.cancel();
      return;
    }
    final runningTimers =
        _listController.getItems().where((timer) => !timer.isStopped).toList();
    if (runningTimers.isEmpty) {
      AwesomeNotifications()
          .cancelNotificationsByChannelKey(timerNotificationChannelKey);
      timerNotificationInterval?.cancel();
      return;
    }
    // Get timer with lowest remaining time
    final timer = runningTimers
        .reduce((a, b) => a.remainingSeconds < b.remainingSeconds ? a : b);

    updateTimerNotification(timer, runningTimers.length);
    timerNotificationInterval?.cancel();
    timerNotificationInterval = Timer.periodic(const Duration(seconds: 1), (t) {
      updateTimerNotification(timer, runningTimers.length);
    });
  }

  void onTimerUpdate() async {
    if (mounted) {
      _listController.reload();
      setState(() {});
      // _listController.changeItems((timers) => {});
    }
    _updateTimerNotification();

    // showProgressNotification();
  }

  @override
  void initState() {
    super.initState();

    _showFilters = appSettings
        .getGroup("Timer")
        .getGroup("Filters")
        .getSetting("Show Filters");
    _showSort = appSettings
        .getGroup("Timer")
        .getGroup("Filters")
        .getSetting("Show Sort");
    _showNotification =
        appSettings.getGroup("Timer").getSetting("Show Notification");
    _showFilters.addListener(update);
    _showSort.addListener(update);
    _showNotification.addListener(update);
    ListenerManager.addOnChangeListener("timers", onTimerUpdate);
    // showProgressNotification();
  }

  @override
  void dispose() {
    _showFilters.removeListener(update);
    _showSort.removeListener(update);
    _showNotification.removeListener(update);

    // ListenerManager.removeOnChangeListener("timers", onTimerUpdate);
    super.dispose();
  }

  Future<void> _onDeleteTimer(ClockTimer deletedTimer) async {
    await deletedTimer.reset();
    _updateTimerNotification();

    // showProgressNotification();
    // _listController.deleteItem(deletedTimer);
  }

  Future<void> _handleToggleState(ClockTimer timer) async {
    await timer.toggleState();
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handleStartTimer(ClockTimer timer) async {
    if (timer.isRunning) return;
    await timer.start();
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handleStartMultipleTimers(List<ClockTimer> timers) async {
    for (var timer in timers) {
      if (timer.isRunning) return;
      await timer.start();
    }
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handlePauseTimer(ClockTimer timer) async {
    if (timer.isPaused) return;
    await timer.pause();
    _listController.changeItems((timers) {});
    _updateTimerNotification();
    // showProgressNotification();
  }

  Future<void> _handlePauseMultipleTimers(List<ClockTimer> timers) async {
    for (var timer in timers) {
      if (timer.isPaused) return;
      await timer.pause();
    }
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handleResetTimer(ClockTimer timer) async {
    await timer.reset();
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handleResetMultipleTimers(List<ClockTimer> timers) async {
    for (var timer in timers) {
      await timer.reset();
    }
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<void> _handleAddTimeToTimer(ClockTimer timer) async {
    await timer.addTime();
    _listController.changeItems((timers) {});
    _updateTimerNotification();

    // showProgressNotification();
  }

  Future<ClockTimer?> _openCustomizeTimerScreen(
    ClockTimer timer, {
    Future<void> Function(ClockTimer)? onSave,
    Future<void> Function()? onCancel,
    bool isNewTimer = false,
  }) async {
    return openCustomizeScreen(
      context,
      CustomizeListItemScreen(
        item: timer,
        isNewItem: isNewTimer,
        headerBuilder: (timerItem) => TimerDurationPicker(timer: timerItem),
      ),
      onSave: onSave,
      onCancel: onCancel,
    );
  }

  Future<ClockTimer?> _handleCustomizeTimer(ClockTimer timer) async {
    await _openCustomizeTimerScreen(timer, onSave: (newTimer) async {
      // Timer id gets reset after copyFrom, so we have to cancel the old one
      await timer.reset();
      timer.copyFrom(newTimer);
      await timer.start();
      _listController.changeItems((timers) {});
    });
    _updateTimerNotification();

    // showProgressNotification();
    return timer;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Expanded(
            child: PersistentListView<ClockTimer>(
              saveTag: 'timers',
              listController: _listController,
              itemBuilder: (timer) => TimerCard(
                key: ValueKey(timer),
                timer: timer,
                onToggleState: () => _handleToggleState(timer),
                onPressDelete: () => _listController.deleteItem(timer),
                onPressDuplicate: () => _listController.duplicateItem(timer),
                onPressReset: () => _handleResetTimer(timer),
                onPressAddTime: () => _handleAddTimeToTimer(timer),
              ),
              onTapItem: (timer, index) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerFullscreen(
                      timer: timer,
                      onReset: _handleResetTimer,
                      onToggleState: _handleToggleState,
                      onAddTime: _handleAddTimeToTimer,
                      onCustomize: _handleCustomizeTimer,
                    ),
                  ),
                );
                _listController.reload();
                // _listController.changeItems((item) {});
              },
              onDeleteItem: _onDeleteTimer,
              isSelectable: true,
              placeholderText: AppLocalizations.of(context)!.noTimerMessage,
              reloadOnPop: true,
              listFilters: _showFilters.value ? timerListFilters : [],
              sortOptions: _showSort.value ? timerSortOptions : [],
              customActions: _showFilters.value
                  ? [
                      ListFilterCustomAction<ClockTimer>(
                          name: "Reset all filtered timers",
                          icon: Icons.timer_off_rounded,
                          action: (timers) =>
                              _handleResetMultipleTimers(timers)),
                      ListFilterCustomAction<ClockTimer>(
                          name: "Play all filtered timers",
                          icon: Icons.play_arrow_rounded,
                          action: (timers) =>
                              _handleStartMultipleTimers(timers)),
                      ListFilterCustomAction<ClockTimer>(
                          name: "Pause all filtered timers",
                          icon: Icons.pause_rounded,
                          action: (timers) =>
                              _handlePauseMultipleTimers(timers)),
                    ]
                  : [],
            ),
          ),
        ],
      ),
      FAB(
        onPressed: () async {
          PickerResult<ClockTimer>? pickerResult =
              await showTimerPicker(context);
          if (pickerResult != null) {
            ClockTimer timer = ClockTimer.from(pickerResult.value);
            if (pickerResult.isCustomize) {
              await _openCustomizeTimerScreen(
                timer,
                onSave: (timer) async {
                  await timer.start();
                  _listController.addItem(timer);
                },
                isNewTimer: true,
              );
            } else {
              await timer.start();
              _listController.addItem(timer);
            }
            _updateTimerNotification();
            // showProgressNotification();
          }
        },
      )
    ]);
  }
}
