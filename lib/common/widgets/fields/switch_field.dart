import 'package:flutter/material.dart';

class SwitchField extends StatefulWidget {
  const SwitchField(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.name,
      this.description = ""});

  final String name;
  final String description;
  final bool value;
  final void Function(bool value)? onChanged;

  @override
  State<SwitchField> createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;



    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onChanged?.call(!widget.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: textTheme.headlineMedium,
                      ),
                      if (widget.description.isNotEmpty)
                        Text(widget.description, style: textTheme.bodyMedium)
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Switch(
                value: widget.value,
                onChanged: widget.onChanged,
              )
            ],
          ),
        ),
      ),
    );
  }
}
