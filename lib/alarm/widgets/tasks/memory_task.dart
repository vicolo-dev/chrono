import 'dart:async';
import 'dart:math';

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

class MemoryTask extends StatefulWidget {
  const MemoryTask({
    super.key,
    required this.onSolve,
    required this.settings,
  });

  final VoidCallback onSolve;
  final SettingGroup settings;

  @override
  State<MemoryTask> createState() => _MemoryTaskState();
}

class _MemoryTaskState extends State<MemoryTask> with TickerProviderStateMixin {
  late final int numberOfPairs =
      widget.settings.getSetting("numberOfPairs").value.toInt();

  late List<CardModel> _cards;
  CardModel? _firstCard;
  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    // Generate pairs of cards
    List<int> cardValues = [
      ...List.generate(numberOfPairs, (index) => index + 1),
      ...List.generate(numberOfPairs, (index) => index + 1)
    ];
    // cardValues.addAll(cardValues); // Duplicate for pairs
    cardValues.shuffle(); // Shuffle the cards

    _cards = cardValues
        .map((value) => CardModel(value: value, isFlipped: false))
        .toList();
  }

  void _onCardTap(CardModel card) {
    if (_isWaiting || card.isFlipped) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = card;
    } else {
      if (_firstCard!.value == card.value) {
        // Match found
        _firstCard!.isCompleted = true;
        card.isCompleted = true;
        _firstCard = null;

        if (_cards.every((card) => card.isFlipped)) {
          // All cards are flipped
          Future.delayed(const Duration(seconds: 1), () {
            widget.onSolve();
          });
        }
      } else {
        // No match, flip back after delay
        _isWaiting = true;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            card.isFlipped = false;
            _firstCard!.isFlipped = false;
            _firstCard = null;
            _isWaiting = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    int gridSize = (sqrt(_cards.length)).floor();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Match card pairs",
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            // height: 512,
            child: GridView.builder(
              itemCount: _cards.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (context, index) {
                CardModel card = _cards[index];
                return GestureDetector(
                  key: ValueKey(card),
                  onTap: () => _onCardTap(card),
                  child: FlipCard(
                    isFlipped: card.isFlipped,
                    front: CardContainer(
                      margin: const EdgeInsets.all(4.0),
                      color: colorScheme.primary,
                      child: Center(
                        child: Text(
                          '?',
                          style: textTheme.displayMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    back: CardContainer(
                      margin: const EdgeInsets.all(4.0),
                      color: card.isCompleted ? Colors.green : Colors.orangeAccent,
                      child: Center(
                        child: Text(
                          '${card.value}',
                          style: textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                                                      
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardModel {
  final int value;
  bool isCompleted = false;
  bool isFlipped;

  CardModel({required this.value, this.isFlipped = false});
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool isFlipped;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isFlipped,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (widget.isFlipped) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        Widget content;
        if (angle <= pi / 2) {
          content = widget.front;
        } else {
          content = widget.back;
          transform.rotateY(pi);
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: content,
        );
      },
    );
  }
}
