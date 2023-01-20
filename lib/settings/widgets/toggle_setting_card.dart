import 'package:clock_app/common/widgets/toggle_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class ToggleSettingCard<T> extends StatelessWidget {
  const ToggleSettingCard(
      {Key? key,
      required this.setting,
      this.summaryView = false,
      this.onChanged})
      : super(key: key);

  final ToggleSetting setting;
  final bool summaryView;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    ToggleCard<T> toggleCard = ToggleCard<T>(
      name: setting.name,
      description: setting.description,
      selectedItems: setting.value,
      options: setting.options
          .map((option) => ToggleOption<T>(option.name, option.value))
          .toList(),
      onChange: (value) {
        setting.toggle(value);
        onChanged?.call();
      },
    );

    return summaryView ? toggleCard : Card(child: toggleCard);
  }
}
