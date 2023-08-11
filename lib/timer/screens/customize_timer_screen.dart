import 'package:clock_app/common/widgets/customize_screen.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
import 'package:flutter/material.dart';

class CustomizeTimerScreen extends StatefulWidget {
  const CustomizeTimerScreen({
    super.key,
    required this.timer,
    required this.isNewItem,
  });

  final ClockTimer timer;
  final bool isNewItem;

  @override
  State<CustomizeTimerScreen> createState() => _CustomizeTimerScreenState();
}

class _CustomizeTimerScreenState extends State<CustomizeTimerScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomizeScreen(
      item: widget.timer,
      isNewItem: widget.isNewItem,
      builder: (context, timer) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    TimeDuration? newTimeDuration = await showDurationPicker(
                      context,
                      initialTimeDuration: timer.duration,
                    );
                    if (newTimeDuration == null) return;
                    setState(() {
                      timer.setDuration(newTimeDuration);
                    });
                  },
                  child: Text(timer.duration.toString(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: timer.remainingSeconds > 3600 ? 48 : 56)),
                ),
                const SizedBox(height: 8),
                ...getSettingWidgets(
                  timer.settings.settingItems,
                  checkDependentEnableConditions: () {
                    setState(() {});
                  },
                  isAppSettings: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
