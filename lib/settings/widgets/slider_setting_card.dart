import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/slider_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SliderSettingCard extends StatefulWidget {
  final SliderSetting setting;
  final bool showAsCard;
  final void Function(double)? onChanged;

  const SliderSettingCard({
    super.key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  });

  @override
  State<SliderSettingCard> createState() => _SliderSettingCardState();
}

class _SliderSettingCardState extends State<SliderSettingCard> {
  @override
  Widget build(BuildContext context) {
    SliderField sliderCard = SliderField(
      title: widget.setting.displayName(context),
      description: widget.setting.displayDescription(context),
      value: widget.setting.value,
      min: widget.setting.min,
      max: widget.setting.max,
      unit: widget.setting.unit,
      snapLength: widget.setting.snapLength,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showAsCard
        ? CardContainer(
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: sliderCard,
          ))
        : sliderCard;
  }
}
