import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/input_bottom_sheet.dart';
import 'package:clock_app/common/widgets/select_bottom_sheet.dart';
import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class SelectCard<T> extends StatefulWidget {
  const SelectCard({
    Key? key,
    required this.selectedIndex,
    required this.title,
    this.description,
    required this.choices,
    required this.onChange,
    this.type = SelectType.text,
    this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final String title;
  final String? description;
  final SelectType type;
  final List<SelectChoice> choices;
  final void Function(int index) onChange;
  final Function(int index)? onSelect;

  @override
  State<SelectCard<T>> createState() => _SelectCardState<T>();
}

enum SelectType { color, text }

class _SelectCardState<T> extends State<SelectCard<T>> {
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
        // shape:
        //     const RoundedRectangleBorder(borderRadius: Theme.of(context).cardTheme.shape as),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void handleSelect(int index) {
                setState(() {
                  _currentSelectedIndex = index;
                  widget.onSelect?.call(index);
                });
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
        widget.onChange(_currentSelectedIndex);
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
                  if (widget.choices[_currentSelectedIndex].runtimeType ==
                      SelectTextChoice)
                    Text(
                      (widget.choices[_currentSelectedIndex]
                              as SelectTextChoice)
                          .title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
              const Spacer(),
              widget.choices[_currentSelectedIndex].runtimeType ==
                      SelectTextChoice
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
                        color: (widget.choices[_currentSelectedIndex]
                                as SelectColorChoice)
                            .color,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
