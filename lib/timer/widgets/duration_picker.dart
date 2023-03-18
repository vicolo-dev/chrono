import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
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
            title: "Choose Duration",
            child: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var width = MediaQuery.of(context).size.width;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(timeDuration.toString(),
                        style: textTheme.displayMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: width - 64,
                      width: width - 64,
                      child: DialDurationPicker(
                        duration: timeDuration,
                        onChange: (TimeDuration newDuration) {
                          setState(() {
                            timeDuration = newDuration;
                          });
                        },
                        showHours: showHours,
                      ),
                    ),
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
