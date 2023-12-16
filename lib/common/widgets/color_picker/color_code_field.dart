import 'package:clock_app/common/utils/color_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import '../color_picker_extensions.dart';
// import '../functions/picker_functions.dart';
// import '../models/color_picker_action_buttons.dart';
// import '../models/color_picker_copy_paste_behavior.dart';
// import '../universal_widgets/dry_intrisinic.dart';

/// Color code entry and display field used by the FlexColorPicker.
@immutable
class ColorCodeField extends StatefulWidget {
  /// Default const constructor.
  const ColorCodeField({
    super.key,
    required this.color,
    this.readOnly = false,
    required this.onColorChanged,
    required this.onEditFocused,
    this.textStyle,
    this.prefixStyle,
    this.colorCodeHasColor = false,
    this.toolIcons = const ColorPickerActionButtons(),
    this.copyPasteBehavior = const ColorPickerCopyPasteBehavior(),
    this.enableTooltips = true,
    this.shouldUpdate = false,
  });

  /// Current color value for the field.
  final Color color;

  /// Is in read only mode.
  ///
  /// Default to false.
  final bool readOnly;

  /// Color code of the entered color string is returned back in this callback.
  final ValueChanged<Color> onColorChanged;

  /// The Color code editing field has focus.
  final ValueChanged<bool> onEditFocused;

  /// TextStyle of the color code display and edit field.
  ///
  /// Defaults to Theme.of(context).textTheme.bodyMedium;
  final TextStyle? textStyle;

  /// The TextStyle of the prefix of the color code.
  ///
  /// Defaults to [textStyle], if not defined.
  final TextStyle? prefixStyle;

  /// If true then the background of the color code entry field uses the current
  /// selected color.
  ///
  /// This makes the color code entry field a larger current color indicator
  /// area that changes color as the color value is changed.
  /// The text color of the filed will adjust to for best contrast as will
  /// the opacity indicator text. Enabling this feature will override any
  /// color specified in [textStyle] and [prefixStyle] but
  /// their styles will otherwise be kept as specified.
  ///
  /// Defaults to false.
  final bool colorCodeHasColor;

  /// Defines icons for the color picker title bar and its actions.
  ///
  /// Defaults to ColorPickerToolIcons().
  final ColorPickerActionButtons toolIcons;

  /// Defines the color picker's copy and paste behavior.
  ///
  /// Defaults to ColorPickerPasteBehavior().
  final ColorPickerCopyPasteBehavior copyPasteBehavior;

  /// Controls if tooltips are shown or not
  ///
  /// Defaults to true.
  final bool enableTooltips;

  /// Should a change on the color value update the field?
  ///
  /// If we are just editing text in the control it should not, we just send
  /// the data out to update any widget using the [color].
  /// However, when we get a new color due to external action is should update.
  /// This is similar to the same property on the wheel.
  ///
  /// Defaults to false.
  final bool shouldUpdate;

  @override
  State<ColorCodeField> createState() => _ColorCodeFieldState();
}

// Color code display and entry field.
class _ColorCodeFieldState extends State<ColorCodeField> {
  late TextEditingController textController;
  late FocusNode textFocusNode;
  late String colorHexCode;
  late Color color;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFocusNode = FocusNode();
    color = widget.color;
    textController.text = color.hex;
  }

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ColorCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color && widget.shouldUpdate) {
      color = widget.color;
      textController.text = color.hex;
    }
  }

  @override
  Widget build(BuildContext context) {
    // The tooltip for copying the color code via the icon button
    String? copyTooltip;

    if (widget.enableTooltips) {
      // Get current platform.
      final TargetPlatform platform = Theme.of(context).platform;
      // Get the Material localizations.
      final MaterialLocalizations translate = MaterialLocalizations.of(context);
      // If shortcut key enabled, make a shortcut platform aware info tooltip.
      String copyKeyTooltip = '';
      if (widget.copyPasteBehavior.ctrlC) {
        copyKeyTooltip = platformControlKey(platform, 'C');
      }
      // Make the Copy tooltip.
      copyTooltip =
          (widget.copyPasteBehavior.copyTooltip ?? translate.copyButtonLabel) +
              copyKeyTooltip;
    }

    // Define opinionated styles for the color code display and entry field.
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final Color fieldBackground = widget.colorCodeHasColor
        ? color
        : isLight
            ? Colors.black.withAlpha(11)
            : Colors.white.withAlpha(33);

    final bool isLightBackground =
        ThemeData.estimateBrightnessForColor(fieldBackground) ==
            Brightness.light;
    final Color textColor = isLight
        ? (isLightBackground || fieldBackground.opacity < 0.5)
            ? Colors.black
            : Colors.white
        : (!isLightBackground || fieldBackground.opacity < 0.5)
            ? Colors.white
            : Colors.black;

    final Color fieldBorder =
        isLight ? Colors.black.withAlpha(33) : Colors.white.withAlpha(55);

    // Set the default text style to bodyMedium if not given.
    TextStyle effectiveStyle = widget.textStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 14);

    TextStyle effectivePrefixStyle = widget.prefixStyle ?? effectiveStyle;

    if (widget.colorCodeHasColor) {
      effectiveStyle = effectiveStyle.copyWith(color: textColor);
      effectivePrefixStyle = effectivePrefixStyle.copyWith(color: textColor);
    }

    // Compute color code field size based on the used font size. Might not
    // always be ideal, but with normal fonts and sizes they have been tested to
    // work well enough visually and to always have room for "DDDDDD", which is
    // usually the widest possible entry string.
    final double fontSize = effectiveStyle.fontSize ?? 14.0;
    final double iconSize = fontSize * 1.1;
    final double borderRadius = fontSize * 1.2;
    final double fieldWidth = fontSize * 10;

    return SizedBox(
      width: fieldWidth,
      // The custom DryIntrinsicWidth layout widget is used due to issue:
      // https://github.com/flutter/flutter/issues/71687
      child: DryIntrinsicWidth(
        child: Focus(
          // Tell the parent when the text edit field has focus.
          onFocusChange: widget.onEditFocused,
          child: TextField(
            enabled: true,
            readOnly: widget.readOnly,
            enableInteractiveSelection: !widget.readOnly,
            controller: textController,
            focusNode: textFocusNode,
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            // Remove line that shows entered chars when maxLength is used.
            buildCounter: (BuildContext context,
                    {required int currentLength,
                    int? maxLength,
                    required bool isFocused}) =>
                null,
            style: effectiveStyle,
            // Only affects the type of keyboard shown on devices, does not
            // make the input uppercase.
            textCapitalization: TextCapitalization.characters,
            // These input formatters limits the input to only valid chars for
            // a hex color code, and we also convert them to uppercase.
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-fA-F0-9]')),
              _UpperCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              suffixIcon: widget.copyPasteBehavior.editFieldCopyButton
                  ? IconButton(
                      icon: Icon(widget.copyPasteBehavior.copyIcon),
                      padding: EdgeInsets.zero,
                      tooltip: copyTooltip,
                      iconSize: iconSize,
                      splashRadius: borderRadius,
                      color: effectiveStyle.color,
                      constraints: const BoxConstraints(),
                      onPressed: _setClipboard,
                    )
                  : SizedBox(height: borderRadius * 2),
              suffixIconConstraints: BoxConstraints(
                minHeight: borderRadius * 2,
                minWidth: borderRadius * 2,
              ),
              isDense: true,
              contentPadding: EdgeInsetsDirectional.only(start: fontSize),
              prefixText: _editColorPrefix,
              prefixStyle: effectivePrefixStyle,
              filled: true,
              fillColor: fieldBackground,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: fieldBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            //
            onChanged: (String textColor) {
              setState(() {
                color = textColor
                    .toColorShort(widget.copyPasteBehavior.parseShortHexCode)
                    .withOpacity(color.opacity);
              });
              widget.onColorChanged(color);
            },
            onEditingComplete: () {
              setState(() {
                color = textController.text
                    .toColorShort(widget.copyPasteBehavior.parseShortHexCode)
                    .withOpacity(color.opacity);
              });
              textController.text = color.hex;
              widget.onColorChanged(color);
              textFocusNode.unfocus();
            },
          ),
        ),
      ),
    );
  }

  // Set current selected color values as a String on the Clipboard in the
  // currently configured format.
  Future<void> _setClipboard() async {
    String colorString = '00000000';
    switch (widget.copyPasteBehavior.copyFormat) {
      case ColorPickerCopyFormat.dartCode:
        colorString = '0x${color.hexAlpha}';
        break;
      case ColorPickerCopyFormat.hexRRGGBB:
        colorString = color.hex;
        break;
      case ColorPickerCopyFormat.hexAARRGGBB:
        colorString = color.hexAlpha;
        break;
      case ColorPickerCopyFormat.numHexRRGGBB:
        colorString = '#${color.hex}';
        break;
      case ColorPickerCopyFormat.numHexAARRGGBB:
        colorString = '#${color.hexAlpha}';
        break;
    }
    final ClipboardData data = ClipboardData(text: colorString);
    await Clipboard.setData(data);
  }

  // Get the current selected color prefix format for the input field.
  // The prefix in the input field matches the set copy format.
  String get _editColorPrefix {
    final String alphaValue = color.hexAlpha.substring(0, 2);
    switch (widget.copyPasteBehavior.copyFormat) {
      case ColorPickerCopyFormat.dartCode:
        return '0x$alphaValue';
      case ColorPickerCopyFormat.hexRRGGBB:
        return '    ';
      case ColorPickerCopyFormat.hexAARRGGBB:
        return '  $alphaValue';
      case ColorPickerCopyFormat.numHexRRGGBB:
        return '   #';
      case ColorPickerCopyFormat.numHexAARRGGBB:
        return ' #$alphaValue';
    }
  }
}

// This TextField formatter converts all input to uppercase.
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
