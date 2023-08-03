import 'package:flutter/material.dart';

class ToggleOption<T> {
  final String name;
  final T value;

  const ToggleOption(this.name, this.value);
}

class ToggleField<T> extends StatefulWidget {
  const ToggleField({
    Key? key,
    required this.selectedItems,
    required this.onChange,
    required this.options,
    this.name,
    this.description,
    this.padding = 0,
    this.innerPadding = 0,
    this.square = true,
  }) : super(key: key);

  final String? name;
  final String? description;
  final List<bool> selectedItems;
  final List<ToggleOption<T>> options;
  final void Function(int) onChange;
  final double padding;
  final double innerPadding;
  final bool square;

  @override
  State<ToggleField<T>> createState() => _ToggleFieldState<T>();
}

class _ToggleFieldState<T> extends State<ToggleField<T>> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Column(
        children: [
          if (widget.name != null) Text(widget.name!),
          ToggleButtons(
            fillColor: theme.colorScheme.primary,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            renderBorder: false,
            constraints: BoxConstraints(
              minHeight: widget.square
                  ? (MediaQuery.of(context).size.width -
                          (40 + widget.padding * 2)) /
                      widget.options.length
                  : 0.0,
              minWidth: (MediaQuery.of(context).size.width -
                      (40 + widget.padding * 2)) /
                  widget.options.length,
            ),
            isSelected: widget.selectedItems,
            onPressed: widget.onChange,
            children: [
              for (final option in widget.options)
                Padding(
                  padding: EdgeInsets.all(widget.innerPadding),
                  child: Text(option.name),
                )
            ],
          ),
        ],
      ),
    );
  }
}
