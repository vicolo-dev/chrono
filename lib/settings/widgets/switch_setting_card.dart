import 'package:clock_app/common/widgets/switch_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SwitchSettingCard extends StatefulWidget {
  final SwitchSetting setting;
  final bool showSummaryView;
  final void Function(bool)? onChanged;

  const SwitchSettingCard(
      {Key? key,
      required this.setting,
      this.showSummaryView = false,
      this.onChanged})
      : super(key: key);

  @override
  State<SwitchSettingCard> createState() => _SwitchSettingCardState();
}

class _SwitchSettingCardState extends State<SwitchSettingCard> {
  @override
  Widget build(BuildContext context) {
    SwitchCard switchCard = SwitchCard(
      name: widget.setting.name,
      value: widget.setting.value,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showSummaryView ? switchCard : Card(child: switchCard);
  }
}