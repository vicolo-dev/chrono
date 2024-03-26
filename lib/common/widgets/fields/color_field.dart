import 'package:clock_app/common/widgets/color_box.dart';
import 'package:clock_app/common/widgets/fields/color_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ColorField extends StatefulWidget {
  const ColorField(
      {super.key,
      required this.value,
      required this.onChange,
      required this.name});

  final String name;
  final Color value;
  final void Function(Color value)? onChange;

  @override
  State<ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  void showSelect() async {
    await showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ColorBottomSheet(
              title: widget.name,
              description: "",
              value: widget.value,
              onChange: widget.onChange,
            );
          },
        );
      },
    );
    // setState(() {
    //   widget.onChange(currentSelectedIndex ?? widget.selectedIndex);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                widget.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              ColorBox(color: widget.value),
            ],
          ),
        ),
      ),
    );
  }
}
