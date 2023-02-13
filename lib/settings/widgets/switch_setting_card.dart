import 'package:clock_app/common/widgets/switch_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SwitchSettingCard extends StatefulWidget {
  final SwitchSetting setting;
  final bool summaryView;
  final VoidCallback? onChanged;

  const SwitchSettingCard(
      {Key? key,
      required this.setting,
      this.summaryView = false,
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
        widget.onChanged?.call();
      },
    );

    return widget.summaryView ? switchCard : Card(child: switchCard);
  }
}
