import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class DynamicMultiSelectSettingCard<T extends ListItem> extends StatefulWidget {
  const DynamicMultiSelectSettingCard({
    super.key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  });
  final DynamicMultiSelectSetting<T> setting;
  final void Function(dynamic)? onChanged;
  final bool showAsCard;

  @override
  State<DynamicMultiSelectSettingCard<T>> createState() =>
      _DynamicMultiSelectSettingCardState<T>();
}

class _DynamicMultiSelectSettingCardState<T extends ListItem>
    extends State<DynamicMultiSelectSettingCard<T>> {
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
      onChanged: (indices) {
        setState(() {
          widget.setting.setIndex(context, indices);
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
