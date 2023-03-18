import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/input_bottom_sheet.dart';
import 'package:clock_app/common/widgets/fields/input_field.dart';
import 'package:clock_app/common/widgets/modal.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/dial_duration_picker.dart';
import 'package:flutter/material.dart';

Future<TimerPreset?> showTimerPresetPicker(BuildContext context,
    {TimerPreset? initialTimerPreset}) async {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  final colorScheme = theme.colorScheme;

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
            // title: "Edit Preset",
            // titleWidget: Row(
            //   children: [
            //     Text(
            //       timerPreset.name,
            //       style: textTheme.displaySmall?.copyWith(
            //         color: colorScheme.onBackground,
            //       ),
            //     ),
            //     const Spacer(),
            //     GestureDetector(
            //       onTap: () async {
            //         String value = timerPreset.name;
            //         await showModalBottomSheet<void>(
            //           context: context,
            //           isScrollControlled: true,
            //           enableDrag: true,
            //           builder: (BuildContext context) {
            //             return StatefulBuilder(
            //               builder:
            //                   (BuildContext context, StateSetter setState) {
            //                 return InputBottomSheet(
            //                   title: "Label",
            //                   initialValue: value,
            //                   isInputRequired: true,
            //                   hintText: "Enter a label",
            //                   onChange: (newValue) {
            //                     setState(() {
            //                       value = newValue;
            //                     });
            //                   },
            //                 );
            //               },
            //             );
            //           },
            //         );
            //         setState(() {
            //           timerPreset.name = value;
            //         });
            //       },
            //       // child: Text(
            //       //   "Edit Label",
            //       //   style: textTheme.displaySmall?.copyWith(
            //       //     color: colorScheme.primary,
            //       //   ),
            //       // ),
            //     ),
            //   ],
            // ),
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
                        decoration: InputDecoration(
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

                      // const SizedBox(height: 16),
                      // CardContainer(
                      //   child: InputField(
                      //     title: "Label",
                      //     onChange: (value) {
                      //       setState(() {
                      //         timerPreset.name = value;
                      //       });
                      //     },
                      //     value: timerPreset.name,
                      //     hintText: "Enter a label",
                      //   ),
                      // ),
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
