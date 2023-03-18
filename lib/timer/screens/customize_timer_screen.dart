import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/common/widgets/clock/clock_display.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
import 'package:flutter/material.dart';

class CustomizeTimerScreen extends StatefulWidget {
  const CustomizeTimerScreen({
    super.key,
    required this.initialTimer,
  });

  final ClockTimer initialTimer;

  @override
  State<CustomizeTimerScreen> createState() => _CustomizeTimerScreenState();
}

class _CustomizeTimerScreenState extends State<CustomizeTimerScreen> {
  late ClockTimer _timer;
  int lastPlayedRingtoneIndex = -1;
  late String dateFormat;

  void setDateFormat(dynamic newDateFormat) {
    setState(() {
      dateFormat = newDateFormat;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = ClockTimer.from(widget.initialTimer);
    appSettings.addSettingListener("Date Format", setDateFormat);
    setDateFormat(appSettings.getSetting("Date Format").value);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener("Date Format", setDateFormat);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, _timer);
            },
            child: const Text("Save"))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  TimeDuration? newTimeDuration = await showDurationPicker(
                    context,
                    initialTimeDuration: _timer.duration,
                  );
                  if (newTimeDuration == null) return;
                  setState(() {
                    _timer.setDuration(newTimeDuration);
                  });
                },
                child: Text(_timer.duration.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: _timer.remainingSeconds > 3600 ? 48 : 56)),
              ),
              const SizedBox(height: 8),
              ...getSettingWidgets(
                _timer.settings,
                checkDependentEnableConditions: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
