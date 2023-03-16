import 'package:flutter/material.dart';

class InputBottomSheet extends StatefulWidget {
  const InputBottomSheet({
    super.key,
    required this.title,
    this.description,
    this.hintText = "",
    required this.onChange,
    required this.initialValue,
    this.isInputRequired = false,
  });

  final String title;
  final String initialValue;
  final String? description;
  final String hintText;
  final void Function(String) onChange;
  final bool isInputRequired;

  @override
  State<InputBottomSheet> createState() => _InputBottomSheetState();
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      widget.onChange(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius:
              (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                  .borderRadius,
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                const SizedBox(height: 12.0),
                SizedBox(
                  height: 4.0,
                  width: 48,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(64),
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6)),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6)),
                      ),
                      // if (description != null) const SizedBox(height: 8.0),
                      // if (description != null)
                      //   Text(
                      //     description!,
                      //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //         color: Theme.of(context)
                      //             .colorScheme
                      //             .onBackground
                      //             .withOpacity(0.6)),
                      //   ),
                      const SizedBox(height: 4.0),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          onPressed: () {
                            if (widget.isInputRequired &&
                                _controller.text.isEmpty) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          child: Text('Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: widget.isInputRequired &&
                                              _controller.text.isEmpty
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.6)
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary)),
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
