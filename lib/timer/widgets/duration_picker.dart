import 'package:flutter/material.dart';

import 'package:clock_app/theme/color.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';

Future<TimeDuration?> showDurationPicker(BuildContext context) {
  return showDialog<TimeDuration>(
    context: context,
    builder: (BuildContext context) {
      TimeDuration duration = TimeDuration(hours: 0, minutes: 5, seconds: 0);
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            title: Text('Select Duration',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: ColorTheme.textColorSecondary,
                    )),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var width = MediaQuery.of(context).size.width;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(duration.toString(),
                        style: Theme.of(context).textTheme.displayMedium),
                    SizedBox(
                      height: width - 32,
                      width: width - 32,
                      child: DialDurationPicker(
                        duration: duration,
                        onChange: (TimeDuration newDuration) {
                          setState(() {
                            duration = newDuration;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: ColorTheme.textColorTertiary)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: ColorTheme.accentColor)),
                onPressed: () {
                  Navigator.of(context).pop(duration);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
