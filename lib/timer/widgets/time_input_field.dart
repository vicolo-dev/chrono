import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class TimeInputField extends StatefulWidget {
  const TimeInputField({super.key});

  @override
  State<TimeInputField> createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  final TextEditingController _txtTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _txtTimeController,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      style: Theme.of(context).textTheme.displayMedium,
      showCursor: false,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        focusedBorder: InputBorder.none,
        hintText: '00:00:00',
        hintStyle: Theme.of(context).textTheme.displayMedium,
      ),
      textAlign: TextAlign.center,
      inputFormatters: <TextInputFormatter>[
        TimeTextInputFormatter() // This input formatter will do the job
      ],
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      // if (value.length == 0) {
      //   leftChunk = '00:00:00';
      //   rightChunk = '';
      // }

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = "${value.substring(6, 7)}:${value.substring(7)}";
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk =
              "${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk =
              "${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7, 8)}${value.substring(8)}";
        } else {
          leftChunk = '';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}";
        } else {
          leftChunk = '';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}:${value.substring(7)}";
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk =
              "${value.substring(0, 1)}:${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(6, 7)}";
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}
