// ignore_for_file: use_super_parameters

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/toggle_field.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget used to select the active color picker
///
/// Not library exposed, private to the library.
@immutable
class PickerSelector extends StatelessWidget {
  /// Default const constructor.
  const PickerSelector({
    Key? key,
    required this.pickers,
    required this.picker,
    required this.onPickerChanged,
  }) : super(key: key);

  /// A map of used picker types to select which segments to show and use.
  final Map<ColorPickerType, bool> pickers;

  /// Current active picker.
  final ColorPickerType picker;

  /// Callback to change picker type.
  final ValueChanged<ColorPickerType> onPickerChanged;

  @override
  Widget build(BuildContext context) {
    List<ToggleOption<ColorPickerType>> options = [
      const ToggleOption("Both", ColorPickerType.both),
      const ToggleOption("Swatch", ColorPickerType.primary),
      const ToggleOption("Accent", ColorPickerType.accent),
      const ToggleOption("Black & White", ColorPickerType.bw),
      const ToggleOption("Custom", ColorPickerType.custom),
      const ToggleOption("Wheel", ColorPickerType.wheel),
    ].where((option) => pickers[option.value]!).toList();

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ToggleField(
          selectedItems:
              options.map((option) => option.value == picker).toList(),
          onChange: (index) {
            onPickerChanged(options[index].value);
          },
          options: options.where((option) => pickers[option.value]!).toList(),
          square: false,
          innerPadding: 12,
        ),
      ),
    );
  }
}
