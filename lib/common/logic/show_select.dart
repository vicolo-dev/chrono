import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_bottom_sheet.dart';
import 'package:flutter/material.dart';

void showSelectBottomSheet(
    BuildContext context, void Function(List<int>? indices) onChanged,
    {required bool multiSelect,
    required String title,
    required String? description,
    required List<SelectChoice> choices,
    required List<int> initialSelectedIndices}) async {
  List<int>? selectedIndices = await showModalBottomSheet<List<int>>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    builder: (BuildContext context) {
      List<int> currentSelectedIndices = initialSelectedIndices;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void handleSelect(int index) {
            setState(() {
              if (multiSelect) {
                if (currentSelectedIndices.contains(index)) {
                  currentSelectedIndices.remove(index);
                } else {
                  currentSelectedIndices.add(index);
                }
              } else {
                currentSelectedIndices = [index];
              }
            });
            Navigator.pop(context, currentSelectedIndices);
          }

          return SelectBottomSheet(
            title: title,
            description: description,
            choices: choices,
            currentSelectedIndices: currentSelectedIndices,
            onSelect: handleSelect,
          );
        },
      );
    },
  );
  onChanged(selectedIndices);
}
