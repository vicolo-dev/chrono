import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/switch_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SwitchSettingCard extends StatefulWidget {
  final SwitchSetting setting;
  final bool showAsCard;
  final void Function(bool)? onChanged;

  const SwitchSettingCard(
      {super.key,
      required this.setting,
      this.showAsCard = false,
      this.onChanged});

  @override
  State<SwitchSettingCard> createState() => _SwitchSettingCardState();
}

class _SwitchSettingCardState extends State<SwitchSettingCard> {
  @override
  Widget build(BuildContext context) {
    SwitchField switchCard = SwitchField(
      name: widget.setting.displayName(context),
      value: widget.setting.value,
      description: widget.setting.displayDescription(context),
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
