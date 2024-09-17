import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/common/widgets/clock/digital_clock_display.dart';
import 'package:clock_app/common/widgets/time_picker.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:flutter/material.dart';

class AlarmTimePicker extends StatefulWidget {
  const AlarmTimePicker({super.key, required this.alarm});

  final Alarm alarm;

  @override
  State<AlarmTimePicker> createState() => _AlarmTimePickerState();
}

class _AlarmTimePickerState extends State<AlarmTimePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DigitalClockDisplay(
        dateTime: widget.alarm.time.toDateTime(),
        horizontalAlignment: ElementAlignment.center,
      ),
      onTap: () async {
        PickerResult<TimeOfDay>? timePickerResult = await showTimePickerDialog(
          context: context,
          initialTime: widget.alarm.time.toTimeOfDay(),
          title: "Select Time",
          cancelText: "Cancel",
          confirmText: "Save",
        );

        if (timePickerResult == null) return;

        setState(() {
          widget.alarm.setTimeFromTimeOfDay(timePickerResult.value);
        });
      },
    );
  }
}
