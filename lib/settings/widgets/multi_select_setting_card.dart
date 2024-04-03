import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class MultiSelectSettingCard<T> extends StatefulWidget {
  const MultiSelectSettingCard({
    super.key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  });
  final MultiSelectSetting<T> setting;
  final void Function(T)? onChanged;
  final bool showAsCard;

  @override
  State<MultiSelectSettingCard<T>> createState() => _MultiSelectSettingCardState<T>();
}

class _MultiSelectSettingCardState<T> extends State<MultiSelectSettingCard<T>> {
  @override
  Widget build(BuildContext context) {
    SelectField selectWidget = SelectField(
      selectedIndices: widget.setting.selectedIndices,
      title: widget.setting.name,
      multiSelect: true,
      choices: widget.setting.options
          .map((option) => SelectChoice(
              name: option.name,
              value: option.value,
              description: option.description))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showAsCard
        ? CardContainer(
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: selectWidget,
          ))
        : selectWidget;
  }
}
