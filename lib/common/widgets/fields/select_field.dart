import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/select_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SelectField<T> extends StatefulWidget {
  const SelectField({
    Key? key,
    required this.selectedIndex,
    required this.title,
    this.description,
    required this.choices,
    required this.onChanged,
    this.shouldCloseOnSelect = true,
    this.type = SelectType.string,
    this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final String title;
  final String? description;
  final SelectType type;
  final List<SelectChoice> choices;
  final void Function(int index) onChanged;
  final Function(int index)? onSelect;
  final bool shouldCloseOnSelect;

  @override
  State<SelectField<T>> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField<T>> {
  late int _currentSelectedIndex;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    void showSelect() async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(16),
        //   ),
        // ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void handleSelect(int index) {
                setState(() {
                  _currentSelectedIndex = index;
                  widget.onSelect?.call(index);
                });
                //close bottom sheet
                if (widget.shouldCloseOnSelect) {
                  Navigator.pop(context);
                }
              }

              return SelectBottomSheet(
                title: widget.title,
                description: widget.description,
                choices: widget.choices,
                currentSelectedIndex: _currentSelectedIndex,
                onSelect: handleSelect,
              );
            },
          );
        },
      );
      setState(() {
        widget.onChanged(_currentSelectedIndex);
      });
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  if (widget.choices[_currentSelectedIndex].type ==
                      SelectType.string)
                    Text(
                      widget.choices[_currentSelectedIndex].value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
              const Spacer(),
              widget.choices[_currentSelectedIndex].type == SelectType.string
                  ? Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    )
                  : Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        color: widget.choices[_currentSelectedIndex].value,
                        borderRadius: (Theme.of(context).cardTheme.shape
                                as RoundedRectangleBorder)
                            .borderRadius,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
