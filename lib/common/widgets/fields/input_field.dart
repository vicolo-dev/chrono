import 'package:clock_app/common/widgets/fields/input_bottom_sheet.dart';
import 'package:flutter/material.dart';

class InputField<T> extends StatefulWidget {
  const InputField({
    super.key,
    required this.title,
    this.description,
    required this.onChange,
    required this.value,
    this.hintText = "Empty",
  });

  final String value;
  final String hintText;
  final String title;
  final String? description;
  final void Function(String value) onChange;

  @override
  State<InputField<T>> createState() => _InputFieldState<T>();
}

class _InputFieldState<T> extends State<InputField<T>> {
  // late int _currentSelectedIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   _currentSelectedIndex = widget.selectedIndex;
  // }

  @override
  Widget build(BuildContext context) {
    void showSelect() async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        // shape:
        //     const RoundedRectangleBorder(borderRadius: Theme.of(context).cardTheme.shape as),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // void handleSelect(int index) {
              //   setState(() {
              //     _currentSelectedIndex = index;
              //     widget.onSelect?.call(index);
              //   });
              // }

              return InputBottomSheet(
                title: widget.title,
                description: widget.description,
                initialValue: widget.value,
                hintText: widget.hintText,
                onChange: widget.onChange,
              );
            },
          );
        },
      );
      // setState(() {
      //   widget.onChange(_currentSelectedIndex);
      // });
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Column(
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
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_drop_down_rounded,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6))
            ],
          ),
        ),
      ),
    );
  }
}
