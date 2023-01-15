import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

class SelectChoice {
  final String title;
  final String? description;

  SelectChoice({required this.title, this.description});
}

class Select<T> extends StatefulWidget {
  const Select({
    Key? key,
    required this.initialSelectedIndex,
    required this.title,
    this.description,
    required this.choices,
    required this.onChange,
    this.onSelect,
  }) : super(key: key);

  final int initialSelectedIndex;
  final String title;
  final String? description;
  final List<SelectChoice> choices;
  final void Function(int index) onChange;
  final Function(int index)? onSelect;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    print("initState: ${widget.initialSelectedIndex}");
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    void showSelect() async {
      await showModalBottomSheet<void>(
        context: context,
        shape:
            const RoundedRectangleBorder(borderRadius: defaultTopBorderRadius),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
                              ?.copyWith(color: ColorTheme.textColorSecondary),
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
                        return InkWell(
                          onTap: () => {
                            setState(() {
                              _selectedIndex = index;
                              widget.onSelect?.call(index);
                            }),
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical:
                                    widget.choices[index].description != null
                                        ? 8.0
                                        : 2.0),
                            child: Row(
                              children: [
                                Radio(
                                  value: index,
                                  groupValue: _selectedIndex,
                                  onChanged: (dynamic value) {},
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.choices[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                    if (widget.choices[index].description !=
                                        null)
                                      const SizedBox(height: 4.0),
                                    if (widget.choices[index].description !=
                                        null)
                                      Text(widget.choices[index].description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      );
      widget.onChange(_selectedIndex);
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
                Text(widget.title,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4.0),
                Text(widget.choices[widget.initialSelectedIndex].title,
                    style: Theme.of(context).textTheme.bodyMedium),
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
    // SmartSelect.single(
    //   selectedValue: selectedValue,
    //   title: title,
    //   choiceItems: choiceItems,
    //   onChange: onChange,
    //   onSelect: (a, b) {
    //     print("onSelect");
    //   },
    //   modalType: S2ModalType.bottomSheet,
    //   modalHeaderStyle: S2ModalHeaderStyle(
    //     textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
    //           color: ColorTheme.textColorSecondary,
    //         ),
    //   ),
    //   choiceBuilder: (context, state, value) {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //       child: Row(
    //         children: [

    //           Radio(
    //               value: value.value,
    //               groupValue: value.group,
    //               onChanged: ((value) => state.onSelect(S2Choice(value: value, title: title)))),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(value.title!,
    //                   style: Theme.of(context).textTheme.titleMedium),
    //               const SizedBox(height: 4.0),
    //               if (value.subtitle != null)
    //                 Text(value.subtitle!,
    //                     style: Theme.of(context).textTheme.bodyMedium),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   tileBuilder: (context, state) {
    //     return InkWell(
    //       onTap: state.showModal,
    //       child: Padding(
    //         padding:
    //             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //         child: Row(
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(state.title!,
    //                     style: Theme.of(context).textTheme.headlineMedium),
    //                 const SizedBox(height: 4.0),
    //                 Text(state.selected.toString(),
    //                     style: Theme.of(context).textTheme.bodyMedium),
    //               ],
    //             ),
    //             const Spacer(),
    //             const Icon(
    //               Icons.arrow_drop_down_rounded,
    //               color: ColorTheme.textColorTertiary,
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
