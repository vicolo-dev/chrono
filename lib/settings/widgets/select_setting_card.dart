import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/select_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SelectSettingCard<T> extends StatelessWidget {
  SelectSettingCard({
    Key? key,
    required this.setting,
    this.summaryView = false,
    this.onChanged,
  }) : super(key: key);
  final SelectSetting<T> setting;
  final VoidCallback? onChanged;
  final bool summaryView;

  @override
  Widget build(BuildContext context) {
    SelectCard selectWidget = SelectCard<T>(
      selectedIndex: setting.selectedIndex,
      title: setting.name,
      choices: setting.options
          .map((option) =>
              SelectChoice(title: option.name, description: option.description))
          .toList(),
      onChange: (value) {
        setting.setValue(value);
        onChanged?.call();
        print("${setting.name}: $value");
      },
      onSelect: setting.onSelectOption,
    );

    return summaryView ? selectWidget : Card(child: selectWidget);
  }
}
