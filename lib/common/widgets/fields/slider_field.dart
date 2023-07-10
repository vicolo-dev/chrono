import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliderField extends StatefulWidget {
  const SliderField(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.min,
      required this.max,
      required this.title,
      this.unit = ''})
      : super(key: key);

  final String title;
  final double value;
  final double min;
  final double max;
  final String unit;
  final void Function(double value) onChanged;

  @override
  State<SliderField> createState() => _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  late final TextEditingController _filterController;
  double _value = 0;

  // _SliderFieldState() {

  // }

  void changeValue(double value) {
    setState(() {
      _value = value;
    });
    widget.onChanged(_value);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    // _filterController =
    //     TextEditingController();
    _filterController = TextEditingController(text: _value.toStringAsFixed(1));
    _filterController.addListener(() {
      setState(() {
        _value = _filterController.text.isEmpty
            ? 0.0
            : double.parse(_filterController.text);
      });
      widget.onChanged(_value);
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Size calcTextSize(int length, TextStyle style) {
    String text = '0' * length;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    String unitText = widget.unit.isEmpty ? '  ' : widget.unit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              SizedBox(
                width:
                    calcTextSize('00 $unitText'.length, textTheme.bodyMedium!)
                        .width,
                // width: 50,
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: false,
                  onTapOutside: ((event) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: _filterController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    suffixStyle: textTheme.bodyMedium,
                    suffixText: unitText,
                  ),
                  style: textTheme.bodyMedium,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                    NumericalRangeFormatter(min: widget.min, max: widget.max),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Slider(
                  value: _value,
                  onChanged: (double value) {
                    _filterController.text = value.toStringAsFixed(1);
                    changeValue(value);
                  },
                  min: widget.min,
                  max: widget.max,
                ),
              ),
              const SizedBox(width: 10),
              // const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (double.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(1));
    } else {
      return double.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}
