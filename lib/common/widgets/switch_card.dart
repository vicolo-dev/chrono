import 'package:flutter/material.dart';

class SwitchCard extends StatefulWidget {
  const SwitchCard(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.name})
      : super(key: key);

  final String name;
  final bool value;
  final void Function(bool value)? onChanged;

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(
              widget.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            Switch(
              value: widget.value,
              onChanged: widget.onChanged,
            )
          ],
        ),
      ),
    );
  }
}
