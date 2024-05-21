import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    BorderRadiusGeometry borderRadius = theme.cardTheme.shape != null
        ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
        : BorderRadius.circular(8.0);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(

        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: borderRadius,
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
                        color: colorScheme.onSurface.withOpacity(0.6)),
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
                        style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6)),
                      ),
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
                            Navigator.pop(context, _controller.text);
                          },
                          child: Text(AppLocalizations.of(context)!.saveButton,
                              style: textTheme.labelMedium?.copyWith(
                                  color: widget.isInputRequired &&
                                          _controller.text.isEmpty
                                      ? colorScheme.onSurface.withOpacity(0.6)
                                      : colorScheme.primary)),
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
