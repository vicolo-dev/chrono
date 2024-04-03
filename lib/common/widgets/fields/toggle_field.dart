import 'package:flutter/material.dart';

class ToggleOption<T> {
  final String name;
  final T value;

  const ToggleOption(this.name, this.value);
}

class ToggleField<T> extends StatefulWidget {
  const ToggleField({
    super.key,
    required this.selectedItems,
    required this.onChange,
    required this.options,
    this.name,
    this.description,
    this.innerPadding = 0,
    this.square = true,
  });

  final String? name;
  final String? description;
  final List<bool> selectedItems;
  final List<ToggleOption<T>> options;
  final void Function(int) onChange;
  final double innerPadding;
  final bool square;

  @override
  State<ToggleField<T>> createState() => _ToggleFieldState<T>();
}

class _ToggleFieldState<T> extends State<ToggleField<T>> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    double parentWidth =
        MediaQuery.of(context).size.width - widget.options.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.name != null) ...[
            Text(
              widget.name!,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 4)
          ],
          ToggleButtons(
            // c
            color: colorScheme.onBackground,
            fillColor: colorScheme.primary,
            selectedColor: colorScheme.onPrimary,
            // renderBorder: false,
            constraints: BoxConstraints(
              minHeight: widget.square
                  ? (parentWidth - (40 + 16 * 2)) / widget.options.length
                  : 0.0,
              minWidth: (parentWidth - (40 + 16 * 2)) / widget.options.length,
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
