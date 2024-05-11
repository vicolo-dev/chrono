import 'package:clock_app/common/logic/show_select.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/popup_action.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/types/tag.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/audio_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/color_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/multi_select_field_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/field_cards/text_field_card.dart';
import 'package:flutter/material.dart';

class SelectField extends StatefulWidget {
  const SelectField({
    super.key,
    required this.getSelectedIndices,
    required this.title,
    this.description,
    required this.getChoices,
    required this.onChanged,
    this.multiSelect = false,
    this.actions = const [],
  });

  final List<int> Function() getSelectedIndices;
  final String title;
  final String? description;
  final bool multiSelect;
  final List<SelectChoice> Function() getChoices;
  final void Function(List<int> indices) onChanged;
  final List<MenuAction> actions;

  @override
  State<SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState<T> extends State<SelectField> {
  Widget _getFieldCard(List<SelectChoice> choices, List<int> selectedIndices) {


    if (widget.multiSelect) {
      List<SelectChoice> selectedChoices =
          selectedIndices.map((index) => choices[index]).toList();
      if (choices.isNotEmpty && choices[0].value.runtimeType == Tag) {
        return MultiSelectFieldCard(
            title: widget.title,
            choices: selectedChoices
                .map((e) => SelectChoice<Tag>(
                    name: e.name,
                    value: e.value,
                    description: e.description,
                    color: e.value.color))
                .toList());
      }
      return MultiSelectFieldCard(title: widget.title, choices: choices);
    } else {
      SelectChoice choice = choices[selectedIndices[0]];
      if (choice.value is Color) {
        return ColorFieldCard(
          choice: SelectChoice<Color>(
              name: choice.name,
              value: choice.value,
              description: choice.description),
          title: widget.title,
        );
      } else if (choice.value is FileItem) {
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
  }

  @override
  Widget build(BuildContext context) {
     List<SelectChoice> choices = widget.getChoices();
    List<int> selectedIndices = widget.getSelectedIndices();

    void showSelect(List<int>? selectedIndices) async {
      setState(() {
        widget.onChanged(selectedIndices ?? widget.getSelectedIndices());
      });
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showSelectBottomSheet(
          context,
          showSelect,
          title: widget.title,
          description: widget.description,
          getChoices: widget.getChoices,
          getCurrentSelectedIndices: widget.getSelectedIndices,
          multiSelect: widget.multiSelect,
          actions: widget.actions,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _getFieldCard(choices, selectedIndices),
        ),
      ),
    );
  }
}
