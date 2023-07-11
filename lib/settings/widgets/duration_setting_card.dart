import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/duration_picker_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class DurationSettingCard extends StatefulWidget {
  final DurationSetting setting;
  final bool showAsCard;
  final void Function(TimeDuration)? onChanged;

  const DurationSettingCard({
    Key? key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DurationSettingCard> createState() => _DurationSettingCardState();
}

class _DurationSettingCardState extends State<DurationSettingCard> {
  @override
  Widget build(BuildContext context) {
    Widget input = DurationPickerField(
      title: widget.setting.name,
      description: widget.setting.description,
      value: widget.setting.value,
      onChange: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showAsCard ? CardContainer(child: input) : input;
  }
}
