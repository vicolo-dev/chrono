import 'dart:math';

import 'package:clock_app/common/utils/text_size.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Operator { add, multiply }

final _random = Random();
int getRandomIntInRange(int min, int max) => min + _random.nextInt(max - min);

class MathTaskDifficultyLevel {
  final List<Operator> operators;
  List<int> _numbers = [];
  String _answer = "";
  String _equation = "";

  String get answer => _answer;
  String get equation => _equation;

  MathTaskDifficultyLevel(this.operators) {
    assert(operators.isNotEmpty);
  }

  void generateProblem() {
    _numbers = List.generate(
        operators.length + 1, (index) => getRandomIntInRange(1, 20));
    _answer = _calculateAnswer();
    _equation = _getEquationString();
  }

  String _getEquationString() {
    String text = "";
    for (int i = 0; i < operators.length; i++) {
      text += "${_numbers[i]}";
      switch (operators[i]) {
        case Operator.add:
          text += " + ";
          break;
        case Operator.multiply:
          text += " × ";
          break;
      }
    }
    text += "${_numbers.last} = ";
    return text;
  }

  String _calculateAnswer() {
    int answer = _numbers[0];
    for (int i = 0; i < operators.length; i++) {
      int nextNumber = _numbers[i + 1];
      switch (operators[i]) {
        case Operator.add:
          answer += nextNumber;
          break;
        case Operator.multiply:
          answer *= nextNumber;
          break;
      }
    }
    return answer.toString();
  }
}

class MathTask extends StatefulWidget {
  const MathTask({
    Key? key,
    required this.onSolve,
    required this.settings,
  }) : super(key: key);

  final VoidCallback onSolve;
  final SettingGroup settings;

  @override
  State<MathTask> createState() => _MathTaskState();
}

class _MathTaskState extends State<MathTask> {
  final TextEditingController _textController = TextEditingController();
  late final MathTaskDifficultyLevel _difficultyLevel =
      widget.settings.getSetting("Difficulty").value;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (_textController.text == _difficultyLevel._answer && !_isSolved) {
        _isSolved = true;
        widget.onSolve.call();
      }
    });
    _difficultyLevel.generateProblem();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
            "Solve the equation",
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          CardContainer(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _difficultyLevel.equation,
                      style: textTheme.displayMedium,
                    ),
                    SizedBox(
                      width: textSize.width + 16,
                      child: TextField(
                        controller: _textController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        style: textTheme.displayMedium,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
