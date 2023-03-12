import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
import 'package:flutter/material.dart';

class TimerPreset {
  String name;
  TimeDuration duration;
  TimerPreset(this.name, this.duration);
}

Future<TimerPreset?> showDurationPicker(
  BuildContext context, {
  TimeDuration initialTime =
      const TimeDuration(hours: 0, minutes: 5, seconds: 0),
  String initialLabel = "",
  bool showHours = true,
  bool showPresets = false,
  bool showCustomize = false,
}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

  return showDialog<TimerPreset>(
    context: context,
    builder: (BuildContext context) {
      List<TimerPreset> presets = [
        TimerPreset("1 min", TimeDuration(minutes: 1)),
        TimerPreset("5 min", TimeDuration(minutes: 5)),
        TimerPreset("Workout", TimeDuration(minutes: 10)),
        TimerPreset("Meditation", TimeDuration(minutes: 15)),
        TimerPreset("10 min", TimeDuration(minutes: 10)),
        TimerPreset("Sleep", TimeDuration(hours: 5)),
      ];

      TimerPreset preset = TimerPreset(initialLabel, initialTime);
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            title: Text('Select Duration',
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                )),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var width = MediaQuery.of(context).size.width;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(preset.duration.toString(),
                          style: textTheme.displayMedium),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: width - 64,
                        width: width - 64,
                        child: DialDurationPicker(
                          duration: preset.duration,
                          onChange: (TimeDuration newDuration) {
                            setState(() {
                              preset.duration = newDuration;
                            });
                          },
                          showHours: showHours,
                        ),
                      ),
                      if (showPresets) const SizedBox(height: 16),
                      if (showPresets)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Presets", style: textTheme.labelMedium),
                            SizedBox(
                              height: 48,
                              width: width - 64,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: presets.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == presets.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Edit",
                                          style: textTheme.labelSmall?.copyWith(
                                              color: colorScheme.primary),
                                        ),
                                      ),
                                    );
                                  }
                                  // if (index == presets.length) {
                                  //   return Padding(
                                  //     padding: const EdgeInsets.all(4.0),
                                  //     child: GestureDetector(
                                  //       onTap: () {
                                  //         setState(() {
                                  //           presets.add(TimerPreset(
                                  //               "New Preset", preset.duration));
                                  //         });
                                  //       },
                                  //       child: Chip(
                                  //         label: Icon(Icons.add),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }

                                  return PresetChip(
                                    preset: presets[index],
                                    onDeleted: () {
                                      setState(() {
                                        presets.removeAt(index);
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        preset = presets[index];
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Cancel',
                        style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.6))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (showCustomize) Spacer(),
                  if (showCustomize)
                    TextButton(
                      child: Text(
                        'Customize',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  TextButton(
                    child: Text(
                      'Save',
                      style: textTheme.labelMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(preset);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

class PresetChip extends StatelessWidget {
  const PresetChip({
    super.key,
    required this.preset,
    this.onTap,
    this.onDeleted,
  });

  final TimerPreset preset;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          // onDeleted: onDeleted,
          label: Text(preset.name, style: textTheme.labelSmall),
        ),
      ),
    );
  }
}
