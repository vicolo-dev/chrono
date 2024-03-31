import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class DynamicSelectSettingCard<T extends ListItem> extends StatefulWidget {
  const DynamicSelectSettingCard({
    Key? key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  }) : super(key: key);
  final DynamicSelectSetting<T> setting;
  final void Function(T)? onChanged;
  final bool showAsCard;

  @override
  State<DynamicSelectSettingCard<T>> createState() =>
      _DynamicSelectSettingCardState<T>();
}

class _DynamicSelectSettingCardState<T extends ListItem>
    extends State<DynamicSelectSettingCard<T>> {
  @override
  Widget build(BuildContext context) {
    SelectField selectWidget = SelectField(
      selectedIndex: widget.setting.selectedIndex,
      title: widget.setting.name,
      choices: widget.setting.options
          .map((option) => SelectChoice(
              name: option.name,
              value: option.value,
              description: option.description))
          .toList(),
      onChanged: (index) {
        setState(() {
          widget.setting.setIndex(context, index);
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
