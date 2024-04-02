import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class SelectColorOptionCard extends StatelessWidget {
  const SelectColorOptionCard({
    super.key,
    required this.isSelected,
    required this.choice,
    required this.index,
    required this.onSelect,
  });

  final bool isSelected;
  final SelectChoice choice;
  final int index;
  final void Function(List<int>) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect([index]),
      child: Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            color: choice.value,
            borderRadius:
                (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                    .borderRadius,
          ),
          child: InkWell(
            onTap: () => onSelect([index]),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          )),
    );
  }
}
