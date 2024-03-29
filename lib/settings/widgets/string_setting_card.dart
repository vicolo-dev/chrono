import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/input_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class StringSettingCard extends StatefulWidget {
  final StringSetting setting;
  final bool showAsCard;
  final void Function(String)? onChanged;

  const StringSettingCard({
    Key? key,
    required this.setting,
    this.showAsCard = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StringSettingCard> createState() => _StringSettingCardState();
}

class _StringSettingCardState extends State<StringSettingCard> {
  @override
  Widget build(BuildContext context) {
    Widget input = InputField(
      title: widget.setting.name,
      description: widget.setting.description,
      value: widget.setting.value,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
      hintText: "Add a label",
    );

    return widget.showAsCard ? CardContainer(child: input) : input;
  }
}
