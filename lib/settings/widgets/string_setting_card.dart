import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/input_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class StringSettingCard extends StatefulWidget {
  final StringSetting setting;
  final bool showSummaryView;
  final void Function(String)? onChanged;

  const StringSettingCard({
    Key? key,
    required this.setting,
    this.showSummaryView = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StringSettingCard> createState() => _StringSettingCardState();
}

class _StringSettingCardState extends State<StringSettingCard> {
  @override
  Widget build(BuildContext context) {
    // SliderCard sliderCard = SliderCard(
    //   name: widget.setting.name,
    //   value: widget.setting.value,
    //   min: widget.setting.min,
    //   max: widget.setting.max,
    //   unit: widget.setting.unit,
    //   onChanged: (value) {
    //     setState(() {
    //       widget.setting.setValue(context, value);
    //     });
    //     widget.onChanged?.call(widget.setting.value);
    //   },
    // );

    Widget input = InputCard(
      title: widget.setting.name,
      description: widget.setting.description,
      value: widget.setting.value,
      onChange: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
      hintText: "Add a label",
    );

    return widget.showSummaryView ? input : CardContainer(child: input);
  }
}
