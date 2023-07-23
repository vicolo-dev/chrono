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
  late final TextEditingController _textController =
      TextEditingController(text: widget.value.toStringAsFixed(1));
  // double _value = 0;

  void changeValue(double value) {
    setState(() {
      // _value = value;
    });
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    // _value = widget.value;
    // _textController
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SliderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _textController.text = widget.value.toStringAsFixed(1);
    }
  }

  Size calcTextSize(String text, TextStyle style) {
    // String text = '0' * length;
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

    Size textSize = calcTextSize('000.0 ${widget.unit}', textTheme.bodyMedium!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              SizedBox(
                width: textSize.width,
                // height: textSize.height,
                // width: 50,
                child: Row(
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        autofocus: false,
                        onTapOutside: ((event) {
                          FocusScope.of(context).unfocus();
                        }),
                        onChanged: (textValue) {
                          if (textValue.isEmpty) {
                            textValue = '0.0';
                          }
                          changeValue(double.parse(textValue));
                        },
                        onSubmitted: (textValue) {
                          if (textValue.isEmpty) {
                            _textController.text = textValue = '0.0';
                          }
                          changeValue(double.parse(textValue));
                        },
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: textTheme.bodyMedium,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}'),
                          ),
                          NumericalRangeFormatter(
                              min: widget.min, max: widget.max),
                        ],
                      ),
                    ),
                    Text(
                      widget.unit,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 4),
              Expanded(
                flex: 7,
                child: Slider(
                  value: widget.value,
                  onChanged: (double value) {
                    _textController.text = value.toStringAsFixed(1);
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
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(1));
    } else {
      return double.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}
