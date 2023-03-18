import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/timer/screens/customize_timer_screen.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
import 'package:flutter/material.dart';

Future<PickerResult<ClockTimer>?> showTimerPicker(
  BuildContext context, {
  ClockTimer? initialTimer,
}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

  return showDialog<PickerResult<ClockTimer>>(
    context: context,
    builder: (BuildContext context) {
      ClockTimer timer = ClockTimer.from(
          initialTimer ?? ClockTimer(const TimeDuration(minutes: 5)));

      List<TimerPreset> presets = loadListSync<TimerPreset>("timerPresets");

      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Modal(
            onSave: () {
              print(timer.toJson());
              Navigator.of(context).pop(PickerResult(timer, false));
            },
            title: "Choose Duration",
            additionalAction: ModalAction(
              title: "Customize",
              onPressed: () async {
                Navigator.of(context).pop(PickerResult(timer, true));
              },
            ),
            child: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(timer.duration.toString(),
                        style: textTheme.displayMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: width - 64,
                      width: width - 64,
                      child: DialDurationPicker(
                        duration: timer.duration,
                        onChange: (TimeDuration newDuration) {
                          setState(() {
                            timer = ClockTimer(newDuration);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Presets", style: textTheme.labelMedium),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                minimumSize: const Size(48, 24),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PresetsScreen(),
                                  ),
                                );

                                List<TimerPreset> newPresets =
                                    loadListSync<TimerPreset>("timerPresets");

                                setState(() {
                                  presets = newPresets;
                                });
                              },
                              child: Text(
                                "Edit",
                                style: textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 48,
                          width: width - 64,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: presets.length,
                            itemBuilder: (context, index) {
                              return PresetChip(
                                preset: presets[index],
                                onTap: () {
                                  setState(() {
                                    timer = ClockTimer(presets[index].duration);
                                    timer.setSetting(
                                        context, "Label", presets[index].name);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
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
