import 'package:flutter/material.dart';

class ToggleOption<T> {
  final String name;
  final T value;

  const ToggleOption(this.name, this.value);
}

class ToggleCard<T> extends StatefulWidget {
  const ToggleCard({
    Key? key,
    required this.selectedItems,
    required this.onChange,
    required this.options,
    this.name,
    this.description,
  }) : super(key: key);

  final String? name;
  final String? description;
  final List<bool> selectedItems;
  final List<ToggleOption<T>> options;
  final void Function(int) onChange;

  @override
  State<ToggleCard<T>> createState() => _ToggleCardState<T>();
}

class _ToggleCardState<T> extends State<ToggleCard<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (name != null) Text(name!),
        ToggleButtons(
          fillColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.onPrimary,
          renderBorder: false,
          constraints: BoxConstraints(
            minHeight: (MediaQuery.of(context).size.width - 40) /
                widget.options.length,
            minWidth: (MediaQuery.of(context).size.width - 40) /
                widget.options.length,
          ),
          isSelected: widget.selectedItems,
          onPressed: widget.onChange,
          children: [for (final option in widget.options) Text(option.name)],
        ),
      ],
    );
  }
}
