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
    required this.pickerLabels,
    required this.picker,
    required this.onPickerChanged,
    this.thumbColor,
    this.textStyle,
    this.columnSpacing = 8,
  }) : super(key: key);

  /// A map of used picker types to select which segments to show and use.
  final Map<ColorPickerType, bool> pickers;

  /// THe labels for the picker segments.
  final Map<ColorPickerType, String> pickerLabels;

  /// Current active picker.
  final ColorPickerType picker;

  /// Callback to change picker type.
  final ValueChanged<ColorPickerType> onPickerChanged;

  /// The thumb color of the selected segment.
  ///
  /// Uses cupertino default light and dark style if not provided.
  final Color? thumbColor;

  /// Text style of the text items in the picker
  ///
  /// If not provided, default to `Theme.of(context).textTheme.bodySmall`.
  final TextStyle? textStyle;

  /// The spacing after the picker. Defaults to 8.
  final double columnSpacing;

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
        padding: EdgeInsets.only(bottom: columnSpacing),
        child: ToggleField(
          selectedItems:
              options.map((option) => option.value == picker).toList(),
          onChange: (index) {
            onPickerChanged(options[index].value);
          },
          options: options.where((option) => pickers[option.value]!).toList(),
          square: false,
          innerPadding: 16,
        ),
      ),
    );
  }
}
