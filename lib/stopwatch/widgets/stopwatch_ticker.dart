import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_comparer.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StopwatchTicker extends StatefulWidget {
  const StopwatchTicker({super.key, required this.stopwatch});

  final ClockStopwatch stopwatch;

  @override
  State<StopwatchTicker> createState() => _StopwatchTickerState();
}

class _StopwatchTickerState extends State<StopwatchTicker> {
  late Setting _showMillisecondsSetting;
  late Setting _showPreviousLapBarSetting;
  late Setting _showFastestLapBarSetting;
  late Setting _showSlowestLapBarSetting;
  late Setting _showAverageLapBarSetting;
  late Ticker ticker;

  void update(dynamic value) {
    setState(() {});
  }

  void tick(Duration elapsed) {
    // var t = elapsed.inMicroseconds * 1e-6;
    // double radius = 100;
    // drawState.x = radius * math.sin(t);
    // drawState.y = radius * math.cos(t);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ticker = Ticker(tick);
    ticker.start();

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
  }

  @override
  void dispose() {
    _showMillisecondsSetting.removeListener(update);
    _showPreviousLapBarSetting.removeListener(update);
    _showFastestLapBarSetting.removeListener(update);
    _showSlowestLapBarSetting.removeListener(update);
    _showAverageLapBarSetting.removeListener(update);

    ticker.stop();
    ticker.dispose();
    // updateNotificationInterval?.cancel();
    // updateNotificationInterval = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TimeDuration.fromMilliseconds(
                      widget.stopwatch.elapsedMilliseconds)
                  .toTimeString(
                      showMilliseconds: _showMillisecondsSetting.value),
              style: textTheme.displayLarge?.copyWith(fontSize: 48),
            ),
            if (_showPreviousLapBarSetting.value) ...[
              const SizedBox(height: 8),
              LapComparer(
                stopwatch: widget.stopwatch,
                comparisonLap: widget.stopwatch.previousLap,
                label: "Previous",
                color: Colors.blue,
              ),
            ],
            if (_showFastestLapBarSetting.value) ...[
              const SizedBox(height: 4),
              LapComparer(
                stopwatch: widget.stopwatch,
                comparisonLap: widget.stopwatch.fastestLap,
                label: "Fastest",
                color: Colors.red,
              ),
            ],
            if (_showSlowestLapBarSetting.value) ...[
              const SizedBox(height: 4),
              LapComparer(
                stopwatch: widget.stopwatch,
                comparisonLap: widget.stopwatch.slowestLap,
                label: "Slowest",
                color: Colors.orange,
              ),
            ],
            if (_showAverageLapBarSetting.value) ...[
              const SizedBox(height: 4),
              LapComparer(
                stopwatch: widget.stopwatch,
                comparisonLap: widget.stopwatch.averageLap,
                label: "Average",
                color: Colors.green,
                showLapNumber: false,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
