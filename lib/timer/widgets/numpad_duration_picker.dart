import 'package:clock_app/theme/text.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class NumpadDurationPicker extends StatefulWidget {
  const NumpadDurationPicker(
      {super.key, required this.duration, required this.onChange});

  final TimeDuration duration;
  final void Function(TimeDuration) onChange;

  @override
  State<NumpadDurationPicker> createState() => _NumpadDurationPickerState();
}

class _NumpadDurationPickerState extends State<NumpadDurationPicker> {
  // String hours = "00";
  // String minutes = "00";
  // String seconds = "00";
  // List<String> timeInput = ["0", "0", "0", "0", "0", "0"];

  @override
  void initState() {
    super.initState();
  }

  List<String> getTimeInput() {
    final hours = widget.duration.hours.toString().padLeft(2, "0");
    final minutes = widget.duration.minutes.toString().padLeft(2, "0");
    final seconds = widget.duration.seconds.toString().padLeft(2, "0");
    return [hours[0], hours[1], minutes[0], minutes[1], seconds[0], seconds[1]];
  }

  void _addDigit(String digit, [int amount = 1]) {
    setState(() {
      final timeInput = getTimeInput();
      for(int i = 0; i < amount; i++) {
        timeInput.removeAt(0);
        timeInput.add(digit);
      }
      _update(timeInput);
    });
  }

  void _removeDigit() {
    setState(() {
      final timeInput = getTimeInput();
      timeInput.removeAt(5);
      timeInput.insert(0, "0");
      _update(timeInput);
    });
  }

  void _update(List<String> timeInput) {
    widget.onChange(TimeDuration(
      hours: int.parse("${timeInput[0]}${timeInput[1]}"),
      minutes: int.parse("${timeInput[2]}${timeInput[3]}"),
      seconds: int.parse("${timeInput[4]}${timeInput[5]}"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final labelStyle = textTheme.headlineLarge
        ?.copyWith(color: colorScheme.onSurface, height: 1);
    final labelUnitStyle =
        textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface);

    final hours = widget.duration.hours.toString().padLeft(2, "0");
    final minutes = widget.duration.minutes.toString().padLeft(2, "0");
    final seconds = widget.duration.seconds.toString().padLeft(2, "0");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(hours, style: labelStyle),
            Text("h", style: labelUnitStyle),
            const SizedBox(width: 10),
            Text(minutes, style: labelStyle),
            Text("m", style: labelUnitStyle),
            const SizedBox(width: 10),
            Text(seconds, style: labelStyle),
            Text("s", style: labelUnitStyle),
          ],
        ),
        SizedBox(
          height: 250,
          width: 200,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index < 9) {
                return TimerButton(
                  label: (index + 1).toString(),
                  onTap: () => _addDigit((index + 1).toString()),
                );
              } else if (index == 9) {
                return TimerButton(
                    label: "00",
                    onTap: () {
                      _addDigit("0", 2);
                    });
              } else if (index == 10) {
                return TimerButton(
                  label: "0",
                  onTap: () => _addDigit("0"),
                );
              } else {
                return TimerButton(
                  label: "⌫",
                  onTap: _removeDigit,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class TimerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TimerButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.headlineMedium
                ?.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
