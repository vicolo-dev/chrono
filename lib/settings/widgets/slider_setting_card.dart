import 'package:clock_app/common/widgets/slider_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SliderSettingCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    SliderCard sliderCard = SliderCard(
      name: setting.name,
      value: setting.value,
      min: setting.min,
      max: setting.max,
      unit: setting.unit,
      onChanged: (value) {
        setting.setValue(value);
        onChanged?.call();
      },
    );

    return summaryView ? sliderCard : Card(child: sliderCard);
  }
}
