import 'package:clock_app/common/widgets/switch_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SwitchSettingCard extends StatelessWidget {
  const SwitchSettingCard(
      {Key? key,
      required this.setting,
      this.summaryView = false,
      this.onChanged})
      : super(key: key);

  final SwitchSetting setting;
  final bool summaryView;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    SwitchCard switchCard = SwitchCard(
      name: setting.name,
      value: setting.value,
      onChanged: (value) {
        setting.setValue(value);
        onChanged?.call();
      },
    );

    return summaryView ? switchCard : Card(child: switchCard);
  }
}
