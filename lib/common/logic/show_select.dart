import 'package:clock_app/common/types/popup_action.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/select_field/select_bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<void> showSelectBottomSheet(
  BuildContext context,
  void Function(List<int>? indices) onChanged, {
  required bool multiSelect,
  required String title,
  required String? description,
  required List<SelectChoice> choices,
  required List<int> initialSelectedIndices,
  List<MenuAction> actions = const [],
}) async {
  List<int>? selectedIndices;

  await showModalBottomSheet<List<int>>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    builder: (BuildContext context) {
      List<int> currentSelectedIndices = initialSelectedIndices;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void handleSelect(List<int> indices) {
            setState(() {
              if (multiSelect) {
                if (indices.length == 1) {
                  if (currentSelectedIndices.contains(indices[0])) {
                    currentSelectedIndices.remove(indices[0]);
                  } else {
                    currentSelectedIndices.add(indices[0]);
                  }
                } else {
                  currentSelectedIndices = indices;
                }
              } else {
                if (indices.length == 1) {
                  currentSelectedIndices = [indices[0]];
                } else {
                  debugPrint("Too many indices");
                }
              }
            });
            if (!multiSelect) {
              Navigator.pop(context, currentSelectedIndices);
            }
            selectedIndices = currentSelectedIndices;
          }

          return SelectBottomSheet(
            title: title,
            description: description,
            choices: choices,
            currentSelectedIndices: currentSelectedIndices,
            onSelect: handleSelect,
            multiSelect: multiSelect,
            actions: actions,
          );
        },
      );
    },
  );
  onChanged(selectedIndices);
}
