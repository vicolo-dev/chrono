import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
import 'package:flutter/material.dart';

class DurationPickerField<T> extends StatefulWidget {
  const DurationPickerField({
    Key? key,
    required this.title,
    this.description,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  final TimeDuration value;
  final String title;
  final String? description;
  final void Function(TimeDuration) onChange;

  @override
  State<DurationPickerField<T>> createState() => _DurationPickerFieldState<T>();
}

enum SelectType { color, text }

class _DurationPickerFieldState<T> extends State<DurationPickerField<T>> {
  @override
  void initState() {
    super.initState();
    // _currentSelectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    void showPicker() async {
      TimeDuration? newTimeDuration = (await showDurationPicker(
        context,
        showHours: false,
        initialTimeDuration: widget.value,
      ));
      if (newTimeDuration == null) return;
      setState(() {
        widget.onChange(newTimeDuration);
      });
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showPicker,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.value.toReadableString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.access_time_rounded,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              )
            ],
          ),
        ),
      ),
    );
  }
}
