import 'dart:math';

import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

class SequenceTask extends StatefulWidget {
  const SequenceTask({
    Key? key,
    required this.onSolve,
    required this.settings,
  }) : super(key: key);

  final VoidCallback onSolve;
  final SettingGroup settings;

  @override
  State<SequenceTask> createState() => _SequenceTaskState();
}

class _SequenceTaskState extends State<SequenceTask>
    with TickerProviderStateMixin {
  late final ThemeData theme = Theme.of(context);
  late final int _gridSize =
      widget.settings.getSetting("Grid size").value.toInt();
  late final int _sequenceLength =
      widget.settings.getSetting("Sequence length").value.toInt();
  late final _itemCount = _gridSize * _gridSize;
  late final List<AnimationController> _animationControllerList = List.generate(
      _itemCount,
      (index) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)));
  late final List<Animation> _colorTweenList = List.generate(
      _itemCount,
      (index) => ColorTween(
              begin: theme.colorScheme.background,
              end: theme.colorScheme.primary)
          .animate(_animationControllerList[index]));
  late final List<int> _sequence = _generateSequence(_sequenceLength);
  final List<int> _enteredSequence = [];
  bool _isShowingSequence = false;

  @override
  void initState() {
    super.initState();
    showSequence();
  }

  @override
  void dispose() {
    for (var controller in _animationControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  final Random _random = Random();

  List<int> _generateSequence(int length) {
    return List.generate(length, (_) => _random.nextInt(_gridSize * _gridSize));
  }

  Future<void> showSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _enteredSequence.clear();
    setState(() {
      _isShowingSequence = true;
    });

    for (int i = 0; i < _sequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _animationControllerList[_sequence[i]].forward();
      });
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _animationControllerList[_sequence[i]].reverse();
      });
    }

    setState(() {
      _isShowingSequence = false;
    });
  }

  void onTap(int index) {
    if (_isShowingSequence) {
      return;
    }
    setState(() {
      if (index != _sequence[_enteredSequence.length]) {
        // Wrong box tapped
        _enteredSequence.clear();

        showSnackBar(context, 'Oops, wrong sequence! Please try again.');
      } else {
        // Correct box tapped
        _enteredSequence.add(index);
        if (_enteredSequence.length == _sequenceLength) {
          widget.onSolve.call();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _isShowingSequence
                ? "Remember the sequence"
                : "Now repeat the sequence",
            style: textTheme.headlineMedium,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _sequenceLength; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              _enteredSequence.length > i
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _gridSize,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        itemCount: _gridSize * _gridSize,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => onTap(index),
                            child: AnimatedBuilder(
                              animation: _colorTweenList[index],
                              builder: (context, child) => CardContainer(
                                color: _colorTweenList[index].value,
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: textTheme.headlineMedium?.copyWith(
                                        color: _colorTweenList[index].value ==
                                                colorScheme.background
                                            ? colorScheme.onBackground
                                            : colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: showSequence,
                      child: const Text("Repeat sequence"),
                    ),
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
