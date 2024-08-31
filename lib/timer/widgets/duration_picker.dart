import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/timer/logic/edit_duration_picker_mode.dart';
import 'package:clock_app/timer/logic/get_duration_picker.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<TimeDuration?> showDurationPicker(
  BuildContext context, {
  TimeDuration initialTimeDuration =
      const TimeDuration(hours: 0, minutes: 5, seconds: 0),
  bool showHours = true,
}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

  return showDialog<TimeDuration>(
    context: context,
    builder: (BuildContext context) {
      TimeDuration timeDuration = initialTimeDuration;

      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Modal(
            onSave: () => Navigator.of(context).pop(timeDuration),
            // title: "Choose Duration",
            child: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                Orientation orientation = MediaQuery.of(context).orientation;

                DurationPickerType type = appSettings
                    .getGroup("General")
                    .getGroup("Display")
                    .getSetting("Duration Picker")
                    .value;

                Widget title() => Row(
                      children: [
                        // const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.durationPickerTitle,
                          style: TimePickerTheme.of(context).helpTextStyle ??
                              textTheme.labelSmall,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => editDurationPickerMode(
                              context, () => setState(() {})),
                          child: Text(
                            AppLocalizations.of(context)!.timePickerModeButton,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                      ],
                    );

                Widget label() => type == DurationPickerType.numpad ? Container() : Text(
                      timeDuration.toString(),
                      style: textTheme.displayMedium,
                    );

                Widget durationPicker() => getDurationPicker(
                      context,
                      type,
                      timeDuration,
                      (TimeDuration newDuration) {
                        setState(() {
                          timeDuration = newDuration;
                        });
                      },
                    );

                return orientation == Orientation.portrait
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          title(),
                          const SizedBox(height: 16),
                          label(),
                          const SizedBox(height: 16),
                          durationPicker(),
                        ],
                      )
                    : Row(children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              title(),
                              const SizedBox(height: 16),
                              label(),
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
                              durationPicker(),
                            ],
                          ),
                        ),
                      ]);
              },
            ),
          );
        },
      );
    },
  );
}
