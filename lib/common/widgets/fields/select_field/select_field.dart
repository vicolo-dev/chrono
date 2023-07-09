import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/audio_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/color_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/text_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SelectField extends StatefulWidget {
  const SelectField({
    Key? key,
    required this.selectedIndex,
    required this.title,
    this.description,
    required this.choices,
    required this.onChanged,
    this.shouldCloseOnSelect = true,
    this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final String title;
  final String? description;
  final List<SelectChoice> choices;
  final void Function(int index) onChanged;
  final Function(int index)? onSelect;
  final bool shouldCloseOnSelect;

  @override
  State<SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState<T> extends State<SelectField> {
  late int _currentSelectedIndex;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.selectedIndex;
  }

  Widget _getFieldCard() {
    SelectChoice choice = widget.choices[_currentSelectedIndex];

    if (choice.value is Color) {
      return ColorFieldCard(
        choice: SelectChoice<Color>(
            name: choice.name,
            value: choice.value,
            description: choice.description),
        title: widget.title,
      );
    }
    if (choice.value is Audio) {
      return AudioFieldCard(
        choice: SelectChoice<Audio>(
            name: choice.name,
            value: choice.value,
            description: choice.description),
        title: widget.title,
      );
    }

    return TextFieldCard(
      choice: choice,
      title: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    void showSelect() async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void handleSelect(int index) {
                setState(() {
                  _currentSelectedIndex = index;
                  widget.onSelect?.call(index);
                });
                //close bottom sheet
                if (widget.shouldCloseOnSelect) {
                  Navigator.pop(context);
                }
              }

              return SelectBottomSheet(
                title: widget.title,
                description: widget.description,
                choices: widget.choices,
                currentSelectedIndex: _currentSelectedIndex,
                onSelect: handleSelect,
              );
            },
          );
        },
      );
      setState(() {
        widget.onChanged(_currentSelectedIndex);
      });
    }

    SelectChoice choice = widget.choices[_currentSelectedIndex];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _getFieldCard(),
        ),
      ),
    );
  }
}
