import 'package:flutter/material.dart';

class SwitchField extends StatefulWidget {
  const SwitchField(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.name})
      : super(key: key);

  final String name;
  final bool value;
  final void Function(bool value)? onChanged;

  @override
  State<SwitchField> createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineMedium,
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
