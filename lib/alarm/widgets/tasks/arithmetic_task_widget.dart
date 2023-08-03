import 'dart:math';

import 'package:clock_app/common/utils/text_size.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ArithmeticOperator { add, multiply }

class ArithmeticTask extends StatefulWidget {
  const ArithmeticTask({
    Key? key,
    required this.onSolve,
  }) : super(key: key);

  final VoidCallback onSolve;

  @override
  State<ArithmeticTask> createState() => _ArithmeticTaskState();
}

class _ArithmeticTaskState extends State<ArithmeticTask> {
  final TextEditingController _textController = TextEditingController();
  //  String _text = "";

  final _random = Random();
  late int _firstNumber;
  late int _secondNumber;
  late ArithmeticOperator _operator;

  int randomInt(int min, int max) => min + _random.nextInt(max - min);

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      // setState(() {
      // _text = _textController.text;
      // });
      if (_textController.text == getAnswer()) {
        widget.onSolve.call();
      }
    });
    _firstNumber = randomInt(1, 10);
    _secondNumber = randomInt(1, 10);
    _operator = ArithmeticOperator.values[_random.nextInt(2)];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String getOperatorString() {
    switch (_operator) {
      case ArithmeticOperator.add:
        return "+";
      case ArithmeticOperator.multiply:
        return "x";
    }
  }

  String getAnswer() {
    switch (_operator) {
      case ArithmeticOperator.add:
        return (_firstNumber + _secondNumber).toString();
      case ArithmeticOperator.multiply:
        return (_firstNumber * _secondNumber).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    Size textSize = calcTextSize('0000', textTheme.displayMedium!);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Solve the equation to dismiss the alarm:",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          CardContainer(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$_firstNumber ${getOperatorString()} $_secondNumber = ",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    width: textSize.width + 16,
                    child: TextField(
                      controller: _textController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      style: Theme.of(context).textTheme.displayMedium,
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
