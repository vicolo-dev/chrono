import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class SelectTextOptionCard extends StatelessWidget {
  const SelectTextOptionCard({
    super.key,
    required this.selectedIndices,
    required this.choice,
    required this.index,
    required this.onSelect,
    required this.multiSelect,
  });

  final bool multiSelect;
  final List<int> selectedIndices;
  final SelectChoice choice;
  final int index;
  final void Function(List<int>) onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect([index]),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: choice.description.isNotEmpty ? 8.0 : 2.0),
          child: Row(
            children: [
              multiSelect
                  ? Checkbox(
                      // checkColor: Colors.white,
                      // fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: selectedIndices.contains(index),
                      onChanged: (bool? value) => onSelect([index]))
                  : Radio(
                      value: index,
                      groupValue: selectedIndices[0],
                      onChanged: (dynamic value) => onSelect([index]),
                    ),
              Expanded(
                flex: 999,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(choice.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    if (choice.description.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        choice.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
