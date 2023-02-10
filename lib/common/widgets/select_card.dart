import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/select_option_card.dart';
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
    this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final String title;
  final String? description;
  final List<SelectChoice> choices;
  final void Function(int index) onChange;
  final Function(int index)? onSelect;

  @override
  State<SelectCard<T>> createState() => _SelectCardState<T>();
}

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
        shape:
            const RoundedRectangleBorder(borderRadius: defaultTopBorderRadius),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void handleSelect(int index) {
                setState(() {
                  _currentSelectedIndex = index;
                  widget.onSelect?.call(index);
                });
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 4.0,
                      width: 48,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: defaultBorderRadius,
                            color: ColorTheme.textColorTertiary),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: ColorTheme.textColorSecondary),
                          ),
                          if (widget.description != null)
                            const SizedBox(height: 8.0),
                          if (widget.description != null)
                            Text(
                              widget.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: ColorTheme.textColorSecondary),
                            ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: widget.choices.length,
                        itemBuilder: (context, index) {
                          return SelectOptionCard(
                            index: index,
                            choice: widget.choices[index],
                            selectedIndex: _currentSelectedIndex,
                            onSelect: handleSelect,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
      setState(() {
        widget.onChange(_currentSelectedIndex);
      });
    }

    return InkWell(
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
                Text(
                  widget.choices[_currentSelectedIndex].title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: ColorTheme.textColorTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
