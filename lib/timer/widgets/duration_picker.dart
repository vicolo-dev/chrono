import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/timer/logic/edit_duration_picker_mode.dart';
import 'package:clock_app/timer/logic/get_duration_picker.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

Future<TimeDuration?> showDurationPicker(
  BuildContext context, {
  TimeDuration initialTimeDuration =
      const TimeDuration(hours: 0, minutes: 5, seconds: 0),
  bool showHours = true,
}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;

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

                Widget title() => Row(
                      children: [
                        Text(
                          "Choose Duration",
                          style: TimePickerTheme.of(context).helpTextStyle ??
                              Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => editDurationPickerMode(
                              context, () => setState(() {})),
                          child: Text(
                            "Mode",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        )
                      ],
                    );

                Widget label() => Text(
                      timeDuration.toString(),
                      style: textTheme.displayMedium,
                    );

                Widget durationPicker() => getDurationPicker(
                      context,
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
