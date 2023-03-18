import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
import 'package:flutter/material.dart';

Future<TimerPreset?> showTimerPresetPicker(BuildContext context,
    {TimerPreset? initialTimerPreset}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;

  return showDialog<TimerPreset>(
    context: context,
    builder: (BuildContext context) {
      TimerPreset timerPreset = TimerPreset.from(initialTimerPreset ??
          TimerPreset("New Preset", const TimeDuration(minutes: 5)));

      TextEditingController controller = TextEditingController(
        text: timerPreset.name,
      );

      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Modal(
            onSave: () => Navigator.of(context).pop(timerPreset),
            child: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var width = MediaQuery.of(context).size.width;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter a label",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            timerPreset.name = value;
                          });
                        },
                        controller: controller,
                      ),
                      const SizedBox(height: 16),
                      Text(timerPreset.duration.toString(),
                          style: textTheme.displayMedium),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: width - 64,
                        width: width - 64,
                        child: DialDurationPicker(
                          duration: timerPreset.duration,
                          onChange: (TimeDuration newDuration) {
                            setState(() {
                              timerPreset.duration = newDuration;
                            });
                          },
                          showHours: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
