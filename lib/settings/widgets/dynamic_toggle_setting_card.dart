import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/toggle_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class DynamicToggleSettingCard<T extends ListItem> extends StatefulWidget {
  const DynamicToggleSettingCard(
      {super.key,
      required this.setting,
      this.showAsCard = false,
      this.onChanged});

  final DynamicToggleSetting<T> setting;
  final bool showAsCard;
  final void Function(dynamic)? onChanged;


  @override
  State<DynamicToggleSettingCard<T>> createState() => _DynamicToggleSettingCardState<T>();
}

class _DynamicToggleSettingCardState<T extends ListItem> extends State<DynamicToggleSettingCard<T>> {
  final offset = 1;
  @override
  Widget build(BuildContext context) {
    ToggleField<T> toggleCard = ToggleField<T>(
      name: widget.setting.displayName(context),
      description: widget.setting.displayDescription(context),
      selectedItems: widget.setting.selectedIndicesBool,
      options: widget.setting.options
          .map((option) =>
              ToggleOption<T>(option.getLocalizedName(context), option.value))
          .toList(),
      onChange: (value) {
        setState(() {
          widget.setting.toggle(context, value);
        });
        print(widget.setting.value);
        widget.onChanged?.call(widget.setting.value);
      },
      // padding: widget.showAsCard ? 16 : 0,
    );

    return widget.showAsCard ? CardContainer(child: toggleCard) : toggleCard;
  }
}

