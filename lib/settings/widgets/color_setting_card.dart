import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/color_field.dart';
import 'package:clock_app/common/widgets/fields/toggle_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class ColorSettingCard extends StatefulWidget {
  const ColorSettingCard(
      {Key? key,
      required this.setting,
      this.showAsCard = false,
      this.onChanged})
      : super(key: key);

  final ColorSetting setting;
  final bool showAsCard;
  final void Function(Color)? onChanged;

  @override
  State<ColorSettingCard> createState() => _ColorSettingCardState();
}

class _ColorSettingCardState<T> extends State<ColorSettingCard> {
  @override
  Widget build(BuildContext context) {
    ColorField toggleCard = ColorField(
      name: widget.setting.name,
      value: widget.setting.value,
      onChange: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });

        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showAsCard ? CardContainer(child: toggleCard) : toggleCard;
  }
}
