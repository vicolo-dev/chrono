import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/select_card.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SelectSettingCard<T> extends StatefulWidget {
  const SelectSettingCard({
    Key? key,
    required this.setting,
    this.showSummaryView = false,
    this.onChanged,
  }) : super(key: key);
  final SelectSetting<T> setting;
  final void Function(T)? onChanged;
  final bool showSummaryView;

  @override
  State<SelectSettingCard<T>> createState() => _SelectSettingCardState<T>();
}

class _SelectSettingCardState<T> extends State<SelectSettingCard<T>> {
  @override
  Widget build(BuildContext context) {
    SelectCard selectWidget = SelectCard<T>(
      selectedIndex: widget.setting.selectedIndex,
      title: widget.setting.name,
      choices: widget.setting.options
          .map((option) =>
              SelectChoice(title: option.name, description: option.description))
          .toList(),
      onChange: (value) {
        setState(() {
          widget.setting.setValue(value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
      onSelect: (index) => widget.setting.onSelectOption(context, index),
    );

    return widget.showSummaryView ? selectWidget : Card(child: selectWidget);
  }
}
