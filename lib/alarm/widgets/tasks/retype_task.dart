import 'dart:math';

import 'package:clock_app/common/utils/text_size.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RetypeTask extends StatefulWidget {
  const RetypeTask({
    super.key,
    required this.onSolve,
    required this.settings,
  });

  final VoidCallback onSolve;
  final SettingGroup settings;

  @override
  State<RetypeTask> createState() => _RetypeTaskState();
}

class _RetypeTaskState extends State<RetypeTask> {
  final TextEditingController _textController = TextEditingController();
  final Random _random = Random();

  late int characterCount;
  late bool includeNumbers;
  late bool includeLowercase;
  late String _chars;
  late double _problemCount;
  int _problemsSolved = 0;

  late String string;

  void initialize() {
    characterCount =
        widget.settings.getSetting("Number of characters").value.toInt();
    includeNumbers = widget.settings.getSetting("Include numbers").value;
    includeLowercase = widget.settings.getSetting("Include lowercase").value;
    _chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ${includeLowercase ? "abcdefghijklmnopqrstuvwxyz" : ""}${includeNumbers ? "0123456789" : ""}";
    _problemCount = widget.settings.getSetting("Number of problems").value;
    _problemsSolved = 0;
    string = _generateRandomString(characterCount);
    _textController.clear();
  }

  @override
  void didUpdateWidget(covariant RetypeTask oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (_textController.text == string && _problemsSolved < _problemCount) {
        _problemsSolved += 1;
        if (_problemsSolved >= _problemCount) {
          widget.onSolve();
        } else {
          setState(() {
            string = _generateRandomString(characterCount);
            _textController.clear();
          });
        }
      }
    });
    initialize();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _generateRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _random.nextInt(_chars.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    Size textSize =
        calcTextSizeFromLength(characterCount + 5, textTheme.displaySmall!);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Retype the characters below",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _problemCount; i++)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    _problemsSolved > i ? Icons.circle : Icons.circle_outlined,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16.0),
          CardContainer(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      string,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: textSize.width + 16,
                      child: TextField(
                        controller: _textController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z0-9]"))
                        ],
                        autofocus: true,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        style: Theme.of(context).textTheme.displaySmall,
                        keyboardType: TextInputType.text,
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
