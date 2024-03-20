import 'package:clock_app/audio/types/audio.dart';
import 'package:clock_app/common/types/file_item.dart';
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
  }) : super(key: key);

  final int selectedIndex;
  final String title;
  final String? description;
  final List<SelectChoice> choices;
  final void Function(int index) onChanged;

  @override
  State<SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState<T> extends State<SelectField> {
  Widget _getFieldCard() {
    SelectChoice choice = widget.choices[widget.selectedIndex];

    if (choice.value is Color) {
      return ColorFieldCard(
        choice: SelectChoice<Color>(
            name: choice.name,
            value: choice.value,
            description: choice.description),
        title: widget.title,
      );
    }
    if (choice.value is FileItem) {
      return AudioFieldCard(
        choice: SelectChoice<FileItem>(
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
      int? currentSelectedIndex = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) {
          int currentSelectedIndex = widget.selectedIndex;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void handleSelect(int index) {
                setState(() {
                  currentSelectedIndex = index;
                });
                Navigator.pop(context, currentSelectedIndex);
              }

              return SelectBottomSheet(
                title: widget.title,
                description: widget.description,
                choices: widget.choices,
                currentSelectedIndex: currentSelectedIndex,
                onSelect: handleSelect,
              );
            },
          );
        },
      );
      setState(() {
        widget.onChanged(currentSelectedIndex ?? widget.selectedIndex);
      });
    }

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
