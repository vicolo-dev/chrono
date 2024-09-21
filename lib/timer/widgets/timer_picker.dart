import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/timer/logic/edit_duration_picker_mode.dart';
import 'package:clock_app/timer/logic/get_duration_picker.dart';
import 'package:clock_app/timer/screens/presets_screen.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          initialTimer ?? ClockTimer(const TimeDuration(minutes: 0)));

      TimerPreset? selectedPreset;
      List<TimerPreset> presets = loadListSync<TimerPreset>("timer_presets");

      return OrientationBuilder(
        builder: (context, orientation) => StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Modal(
              onSave: () {
                Navigator.of(context).pop(PickerResult(timer, false));
              },
              isSaveEnabled: timer.duration.inSeconds > 0,
              // title: "Choose Duration",
              additionalAction: ModalAction(
                title: AppLocalizations.of(context)!.customizeButton,
                onPressed: () async {
                  Navigator.of(context).pop(PickerResult(timer, true));
                },
              ),
              child: Builder(
                builder: (context) {
                  var width = MediaQuery.of(context).size.width;

                  DurationPickerType type = appSettings
                      .getGroup("General")
                      .getGroup("Display")
                      .getSetting("Duration Picker")
                      .value;

                  Widget presetChips(double width) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .presetsSetting,
                                    style: textTheme.labelMedium),
                                const Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    minimumSize: const Size(48, 24),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PresetsScreen(),
                                      ),
                                    );

                                    List<TimerPreset> newPresets =
                                        loadListSync<TimerPreset>(
                                            "timer_presets");

                                    setState(() {
                                      presets = newPresets;
                                    });
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.editButton,
                                    style: textTheme.labelSmall
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width - 64,
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: presets.length,
                                itemBuilder: (context, index) {
                                  return PresetChip(
                                    isSelected:
                                        presets[index] == selectedPreset,
                                    preset: presets[index],
                                    onTap: () {
                                      setState(() {
                                        timer =
                                            ClockTimer(presets[index].duration);
                                        selectedPreset = presets[index];
                                        timer.setSetting(context, "Label",
                                            presets[index].name);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ]);

                  Widget durationPicker(double width) => getDurationPicker(
                        context,
                        type,
                        timer.duration,
                        (TimeDuration newDuration) {
                          setState(() {
                            timer = ClockTimer(newDuration);
                          });
                        },
                        preset: selectedPreset,
                      );
                  Widget label() => Text(
                        timer.duration.toString(),
                        style: textTheme.displayMedium,
                      );

                  Widget title() => Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.durationPickerTitle,
                            style: TimePickerTheme.of(context).helpTextStyle ??
                                Theme.of(context).textTheme.labelSmall,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => editDurationPickerMode(
                                context, () => setState(() {})),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .timePickerModeButton,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          )
                        ],
                      );

                  return orientation == Orientation.portrait
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            title(),
                            if (type != DurationPickerType.numpad)
                              const SizedBox(height: 16),
                            if (type != DurationPickerType.numpad) label(),
                            const SizedBox(height: 16),
                            durationPicker(width),
                            const SizedBox(height: 16),
                            presetChips(width),
                          ],
                        )
                      : Row(children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (type != DurationPickerType.numpad)
                                  const SizedBox(height: 16),
                                if (type != DurationPickerType.numpad) title(),
                                const SizedBox(height: 16),
                                label(),
                                const SizedBox(height: 16),
                                presetChips(width),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),
                                durationPicker(width),
                              ],
                            ),
                          ),
                        ]);
                },
              ),
            );
          },
        ),
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
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check_circle_outline_rounded,
                      color: colorScheme.onPrimary, size: 20),
                if (isSelected) const SizedBox(width: 8),
                Text(
                  preset.name.length > 20
                      ? preset.name.replaceRange(20, preset.name.length, '...')
                      : preset.name,
                  style: textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onBackground,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
