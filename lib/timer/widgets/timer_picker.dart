import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/modal.dart';
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
      TimerPreset? selectedPreset;

      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Modal(
            onSave: () {
              Navigator.of(context).pop(PickerResult(timer, false));
            },
            isSaveEnabled: timer.duration.inSeconds > 0,
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
                                    builder: (context) => const PresetsScreen(),
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
                                isSelected: presets[index] == selectedPreset,
                                preset: presets[index],
                                onTap: () {
                                  setState(() {
                                    timer = ClockTimer(presets[index].duration);
                                    selectedPreset = presets[index];
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
    required this.isSelected,
  });

  final bool isSelected;
  final TimerPreset preset;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        onTap: onTap,
        child: CardContainer(
          margin: const EdgeInsets.symmetric(vertical: 8),
          showShadow: false,
          // blurStyle: BlurStyle.outer,
          // elevationMultiplier: 0,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onBackground.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: [
              if (isSelected)
                Icon(Icons.check_circle_outline_rounded,
                    color: colorScheme.onPrimary, size: 20),
              if (isSelected) const SizedBox(width: 8),
              Text(preset.name,
                  style: textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onBackground,
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
