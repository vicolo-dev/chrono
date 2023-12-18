import 'package:clock_app/common/widgets/fields/input_bottom_sheet.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.title,
    this.description,
    required this.onChanged,
    required this.value,
    this.hintText = "Empty",
  });

  final String value;
  final String hintText;
  final String title;
  final String? description;
  final void Function(String value) onChanged;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState<T> extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    void showSelect() async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return InputBottomSheet(
                title: widget.title,
                description: widget.description,
                initialValue: widget.value,
                hintText: widget.hintText,
                onChange: widget.onChanged,
              );
            },
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 999,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4.0),
                    // const Spacer(),
                    Text(
                      widget.value.isNotEmpty ? widget.value : widget.hintText,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6))
            ],
          ),
        ),
      ),
    );
  }
}
