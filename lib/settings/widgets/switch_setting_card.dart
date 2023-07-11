import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/switch_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SwitchSettingCard extends StatefulWidget {
  final SwitchSetting setting;
  final bool showAsCard;
  final void Function(bool)? onChanged;

  const SwitchSettingCard(
      {Key? key,
      required this.setting,
      this.showAsCard = false,
      this.onChanged})
      : super(key: key);

  @override
  State<SwitchSettingCard> createState() => _SwitchSettingCardState();
}

class _SwitchSettingCardState extends State<SwitchSettingCard> {
  @override
  Widget build(BuildContext context) {
    SwitchField switchCard = SwitchField(
      name: widget.setting.name,
      value: widget.setting.value,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showAsCard ? CardContainer(child: switchCard) : switchCard;
  }
}
