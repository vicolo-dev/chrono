import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/linear_progress_bar.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/stopwatch/logic/stopwatch_notification.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:timer_builder/timer_builder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final _listController = ListController<Lap>();
  late Setting _showMillisecondsSetting;
  late Setting _showPreviousLapBarSetting;
  late Setting _showFastestLapBarSetting;
  late Setting _showSlowestLapBarSetting;
  late Setting _showAverageLapBarSetting;
  late Setting _showNotificationSetting;
  Timer? updateNotificationInterval;

  late final ClockStopwatch _stopwatch;

  void update(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = loadListSync<ClockStopwatch>('stopwatches').first;
    _showMillisecondsSetting = appSettings
        .getGroup("Stopwatch")
        .getGroup("Time Format")
        .getSetting("Show Milliseconds");
    _showMillisecondsSetting.addListener(update);

    SettingGroup lapComparisonSettings =
        appSettings.getGroup("Stopwatch").getGroup("Comparison Lap Bars");

    _showPreviousLapBarSetting =
        lapComparisonSettings.getSetting("Show Previous Lap");
    _showFastestLapBarSetting =
        lapComparisonSettings.getSetting("Show Fastest Lap");
    _showSlowestLapBarSetting =
        lapComparisonSettings.getSetting("Show Slowest Lap");
    _showAverageLapBarSetting =
        lapComparisonSettings.getSetting("Show Average Lap");
    _showPreviousLapBarSetting.addListener(update);
    _showFastestLapBarSetting.addListener(update);
    _showSlowestLapBarSetting.addListener(update);
    _showAverageLapBarSetting.addListener(update);

    _showNotificationSetting =
        appSettings.getGroup("Stopwatch").getSetting("Show Notification");

    ListenerManager.addOnChangeListener('stopwatch', _handleStopwatchChange);

    if (_stopwatch.isRunning) {
      showProgressNotification();
    }
  }

  void _handleStopwatchChange() {
    final newList = loadListSync<ClockStopwatch>('stopwatches');
    if (mounted) {
      newList.first.laps
          .where((lap) => !_stopwatch.laps.contains(lap))
          .forEach((lap) => _listController.addItem(lap));

      setState(() {});
    }
    _stopwatch.copyFrom(newList.first);
    showProgressNotification();
  }

  @override
  void dispose() {
    _showMillisecondsSetting.removeListener(update);
    _showPreviousLapBarSetting.removeListener(update);
    _showFastestLapBarSetting.removeListener(update);
    _showSlowestLapBarSetting.removeListener(update);
    _showAverageLapBarSetting.removeListener(update);
    _showNotificationSetting.removeListener(update);

    // updateNotificationInterval?.cancel();
    // updateNotificationInterval = null;

    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _stopwatch.pause();
      _stopwatch.reset();
    });
    saveList('stopwatches', [_stopwatch]);

    showProgressNotification();
  }

  void _handleAddLap() {
    if (_stopwatch.currentLapTime.inMilliseconds == 0) return;
    _listController.addItem(_stopwatch.getLap());
    saveList('stopwatches', [_stopwatch]);
    showProgressNotification();
  }

  void _handleToggleState() {
    setState(() {
      _stopwatch.toggleState();
    });
    saveList('stopwatches', [_stopwatch]);
    if (_stopwatch.isRunning) {
      showProgressNotification();
    } else {
      updateNotificationInterval?.cancel();
      updateNotificationInterval = null;
      showProgressNotification();
    }
  }

  Future<void> showProgressNotification() async {
    if (!_showNotificationSetting.value) {
      AwesomeNotifications()
          .cancelNotificationsByChannelKey(stopwatchNotificationChannelKey);
      updateNotificationInterval?.cancel();
      updateNotificationInterval = null;
      return;
    }
    updateStopwatchNotification(_stopwatch);
    updateNotificationInterval?.cancel();
    if (!_stopwatch.isStarted) {
      AwesomeNotifications()
          .cancelNotificationsByChannelKey(stopwatchNotificationChannelKey);
      updateNotificationInterval?.cancel();
      updateNotificationInterval = null;
    } else {
      updateNotificationInterval =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        updateStopwatchNotification(_stopwatch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    timeDilation = 0.5;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimerBuilder.periodic(const Duration(milliseconds: 30),
                builder: (context) {
              // print(_stopwatch.fastestLap?.lapTime.toTimeString());
              // print(_stopwatch.slowestLap?.lapTime.toTimeString());
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TimeDuration.fromMilliseconds(
                                _stopwatch.elapsedMilliseconds)
                            .toTimeString(
                                showMilliseconds: _showMillisecondsSetting.value),
                        style: textTheme.displayLarge?.copyWith(fontSize: 48),
                      ),
                      if (_showPreviousLapBarSetting.value) ...[
                        const SizedBox(height: 8),
                        LapComparer(
                          stopwatch: _stopwatch,
                          comparisonLap: _stopwatch.previousLap,
                          label: "Previous",
                          color: Colors.blue,
                        ),
                      ],
                      if (_showFastestLapBarSetting.value) ...[
                        const SizedBox(height: 4),
                        LapComparer(
                          stopwatch: _stopwatch,
                          comparisonLap: _stopwatch.fastestLap,
                          label: "Fastest",
                          color: Colors.red,
                        ),
                      ],
                      if (_showSlowestLapBarSetting.value) ...[
                        const SizedBox(height: 4),
                        LapComparer(
                          stopwatch: _stopwatch,
                          comparisonLap: _stopwatch.slowestLap,
                          label: "Slowest",
                          color: Colors.orange,
                        ),
                      ],
                      if (_showAverageLapBarSetting.value) ...[
                        const SizedBox(height: 4),
                        LapComparer(
                          stopwatch: _stopwatch,
                          comparisonLap: _stopwatch.averageLap,
                          label: "Average",
                          color: Colors.green,
                          showLapNumber: false,
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Expanded(
              child: CustomListView<Lap>(
                items: _stopwatch.laps,
                listController: _listController,
                itemBuilder: (lap) => LapCard(
                  key: ValueKey(lap),
                  lap: lap,
                ),
                placeholderText: "No laps yet",
                isDeleteEnabled: false,
                isDuplicateEnabled: false,
                isReorderable: false,
                onAddItem: (lap) => _stopwatch.updateFastestAndSlowestLap(),
              ),
            ),
          ],
        ),
        FAB(
          onPressed: _handleToggleState,
          icon: _stopwatch.isRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          size: 2,
        ),
        if (_stopwatch.isStarted)
          FAB(
            index: 1,
            onPressed: _handleAddLap,
            icon: Icons.flag_rounded,
            size: 2,
          ),
        if (_stopwatch.isStarted)
          FAB(
            index: 0,
            position: FabPosition.bottomLeft,
            onPressed: _handleReset,
            icon: Icons.refresh_rounded,
            size: 1,
          ),
      ],
    );
  }
}

class LapComparer extends StatelessWidget {
  const LapComparer({
    super.key,
    required ClockStopwatch stopwatch,
    required this.comparisonLap,
    required this.label,
    this.showLapNumber = true,
    this.color = Colors.green,
  }) : _stopwatch = stopwatch;

  final Lap? comparisonLap;
  final ClockStopwatch _stopwatch;
  final String label;
  final Color color;
  final bool showLapNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinearProgressBar(
          minHeight: 16,
          value: _stopwatch.currentLapTime.inMilliseconds /
              (comparisonLap?.lapTime.inMilliseconds ?? double.infinity),
          backgroundColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0),
          child: Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
              const Spacer(),
              Text(
                  comparisonLap != null
                      ? '${showLapNumber ? "Lap ${comparisonLap?.number}: " : ""}${comparisonLap?.lapTime.toTimeString(showMilliseconds: true)}'
                      : '',
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
