import 'package:clock_app/common/widgets/slider_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SliderSettingCard extends StatefulWidget {
  final SliderSetting setting;
  final bool summaryView;
  final VoidCallback? onChanged;

  const SliderSettingCard({
    Key? key,
    required this.setting,
    this.summaryView = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SliderSettingCard> createState() => _SliderSettingCardState();
}

class _SliderSettingCardState extends State<SliderSettingCard> {
  @override
  Widget build(BuildContext context) {
    SliderCard sliderCard = SliderCard(
      name: widget.setting.name,
      value: widget.setting.value,
      min: widget.setting.min,
      max: widget.setting.max,
      unit: widget.setting.unit,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(value);
        });
        widget.onChanged?.call();
      },
    );

    return widget.summaryView ? sliderCard : Card(child: sliderCard);
  }
}
