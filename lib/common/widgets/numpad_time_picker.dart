import 'dart:async';
import 'package:flutter/material.dart';

enum _CursorPosition {
  hourTens,
  hourOnes,
  minuteTens,
  minuteOnes,
}

/// A Flutter widget that allows the user to select a time (HH:MM)
/// via a numeric pad with a blinking cursor on one digit at a time.
class NumpadTimePicker extends StatefulWidget {
  const NumpadTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChange,
    this.use24hFormat = false,
    this.blinkSpeed = const Duration(milliseconds: 500),
  });

  /// The initial time to display.
  final TimeOfDay initialTime;

  /// Callback whenever the user changes the time.
  final ValueChanged<TimeOfDay> onTimeChange;

  /// If true, uses 24-hour format (00–23).
  /// If false, uses 12-hour format (01–12) with AM/PM.
  final bool use24hFormat;

  /// Controls the blinking speed on the cursor digit (fade in/out).
  final Duration blinkSpeed;

  @override
  State<NumpadTimePicker> createState() => _NumpadTimePickerState();
}

class _NumpadTimePickerState extends State<NumpadTimePicker>
    with SingleTickerProviderStateMixin {
  late int _hours;    // 0..23 in 24h mode, or 1..12 in 12h mode
  late int _minutes;  // 0..59
  late bool _isAm;    // Only relevant if use24hFormat=false

  _CursorPosition? _cursorPosition;

  late AnimationController _blinkController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Convert initialTime to local fields:
    _hours = widget.initialTime.hour;   // e.g. 5 if 05:32
    _minutes = widget.initialTime.minute;

    if (widget.use24hFormat) {
      // For 24h mode, 0..23 is valid
      _isAm = _hours < 12; 
    } else {
      // Convert 24h to 12h
      _isAm = _hours < 12;
      if (_hours == 0) {
        _hours = 12; // 0 => 12 AM
      } else if (_hours > 12) {
        _hours = _hours - 12;
      }
    }

    // Start the cursor on the hour tens digit
    _cursorPosition = _CursorPosition.hourTens;

    // Setup blinking animation
    _blinkController = AnimationController(
      vsync: this,
      duration: widget.blinkSpeed,
      lowerBound: 0.2,
      upperBound: 1.0,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _blinkController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _blinkController.forward();
        }
      });
    _opacityAnimation = _blinkController;
    _blinkController.forward();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  // Helper: convert 12h to 24h
  int _to24HourFormat(int hour12, bool isAm) {
    // 12 AM => 0
    // 12 PM => 12
    if (hour12 == 12) {
      return isAm ? 0 : 12;
    }
    return isAm ? hour12 : hour12 + 12;
  }

  // Call parent's onTimeChange with the correct 24-hour-based hour
  void _notifyChange() {
    int newHour;
    if (widget.use24hFormat) {
      newHour = _hours; // 0..23
    } else {
      newHour = _to24HourFormat(_hours, _isAm);
    }
    widget.onTimeChange(TimeOfDay(hour: newHour, minute: _minutes));
  }

  bool _isValidHour(int h) {
    if (widget.use24hFormat) {
      return (h >= 0 && h <= 23);
    } else {
      return (h >= 1 && h <= 12);
    }
  }

  bool _isValidMinute(int m) => (m >= 0 && m <= 59);

  /// Advance the cursor to the "next" digit in order:
  /// hourTens → hourOnes → minuteTens → minuteOnes → disable (null)
  void _moveCursorForward() {
    setState(() {
      switch (_cursorPosition) {
        case _CursorPosition.hourTens:
          _cursorPosition = _CursorPosition.hourOnes;
          break;
        case _CursorPosition.hourOnes:
          _cursorPosition = _CursorPosition.minuteTens;
          break;
        case _CursorPosition.minuteTens:
          _cursorPosition = _CursorPosition.minuteOnes;
          break;
        case _CursorPosition.minuteOnes:
        case null:
          _cursorPosition = null;
          break;
      }
    });
  }

  /// Skip the next cursor and move two steps forward:
  /// hourTens → minuteTens → minuteOnes → disable
  /// or hourTens → minuteTens → (if we skip minuteOnes, disable).
  void _skipNextCursor() {
    setState(() {
      switch (_cursorPosition) {
        case _CursorPosition.hourTens:
          // skip hourOnes → minuteTens
          _cursorPosition = _CursorPosition.minuteTens;
          break;
        case _CursorPosition.hourOnes:
          // skip minuteTens → minuteOnes
          _cursorPosition = _CursorPosition.minuteOnes;
          break;
        case _CursorPosition.minuteTens:
          // skip minuteOnes → disable
          _cursorPosition = null;
          break;
        case _CursorPosition.minuteOnes:
        case null:
          // already at the end
          _cursorPosition = null;
          break;
      }
    });
  }

  /// Tap on a digit in the UI to move the cursor there (and restart blinking).
  void _onDigitTap(_CursorPosition position) {
    setState(() {
      _cursorPosition = position;
      _blinkController.forward(from: 0.2);
    });
  }

  /// Called when pressing a numeric key (0-9).
  /// We'll apply logic depending on the current cursor position.
  void _onDigitInput(int digit) {
    if (_cursorPosition == null) return;

    switch (_cursorPosition!) {
      case _CursorPosition.hourTens:
        _handleHourTensInput(digit);
        break;
      case _CursorPosition.hourOnes:
        _handleHourOnesInput(digit);
        break;
      case _CursorPosition.minuteTens:
        _handleMinuteTensInput(digit);
        break;
      case _CursorPosition.minuteOnes:
        _handleMinuteOnesInput(digit);
        break;
    }
  }

  // =========== Hour Tens Logic (UPDATED!) ===========
  void _handleHourTensInput(int digit) {
    // Instead of forming digit*10 + oldOnes,
    // we interpret the pressed key as the new TENS place only.
    // Example: pressing '1' => 10, pressing '2' => 20, etc.
    final normalCandidate = digit * 10;

    if (_isValidHour(normalCandidate)) {
      // If 10 (for digit=1) is valid in 12h or 24h, set it
      setState(() {
        _hours = normalCandidate;
      });
      _moveCursorForward();
    } else {
      // fallback => hour = single digit
      // E.g. press '2' => normalCandidate=20 => invalid in 12h => fallback=2
      if (_isValidHour(digit)) {
        setState(() {
          _hours = digit;
        });
        _skipNextCursor(); // skip hourOnes
      } else {
        // if even fallback is invalid, skip
        _skipNextCursor();
      }
    }
    _notifyChange();
  }

  // =========== Hour Ones Logic ===========
 
void _handleHourOnesInput(int digit) {
  final tens = _hours ~/ 10; // e.g., if _hours=10 => tens=1
  final normalCandidate = tens * 10 + digit;
  if (_isValidHour(normalCandidate)) {
    // normal path
    setState(() {
      _hours = normalCandidate;
    });
    _moveCursorForward();
  } else {
    // fallback => single-digit hour
    if (_isValidHour(digit)) {
      setState(() {
        _hours = digit;
      });
      // move only one step forward, NOT skip
      _moveCursorForward(); 
    } else {
      // if fallback is also invalid, then skip
      _skipNextCursor();
    }
  }
  _notifyChange();
}

  // =========== Minute Tens Logic ===========
  void _handleMinuteTensInput(int digit) {
    final oldOnes = _minutes % 10;
    final normalCandidate = digit * 10 + oldOnes;
    if (_isValidMinute(normalCandidate)) {
      setState(() {
        _minutes = normalCandidate;
      });
      _moveCursorForward();
    } else {
      // fallback => just 'digit' as minutes
      if (_isValidMinute(digit)) {
        setState(() {
          _minutes = digit;
        });
        _skipNextCursor();
      } else {
        _skipNextCursor();
      }
    }
    _notifyChange();
  }

  // =========== Minute Ones Logic ===========
  void _handleMinuteOnesInput(int digit) {
    final tens = _minutes ~/ 10;
    final normalCandidate = tens * 10 + digit;
    if (_isValidMinute(normalCandidate)) {
      setState(() {
        _minutes = normalCandidate;
      });
      // We've filled the 4th digit => disable
      _moveCursorForward(); // sets cursor to null
    } else {
      // fallback => set minutes = digit?
      if (_isValidMinute(digit)) {
        setState(() {
          _minutes = digit;
        });
      }
      _moveCursorForward();
    }
    _notifyChange();
  }

  // Toggle AM/PM for 12h mode
  void _onToggleAmPm() {
    if (widget.use24hFormat) return;
    setState(() {
      _isAm = !_isAm;
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    double originalWidth = MediaQuery.of(context).size.width;

    // For display:
    final hh = _hours.toString().padLeft(2, '0'); 
    final mm = _minutes.toString().padLeft(2, '0');
    final amPmText = widget.use24hFormat ? '' : (_isAm ? 'AM' : 'PM');
           final textStyle = textTheme.displayLarge
        ?.copyWith(color: colorScheme.onSurface, height: 1, fontSize: 48);


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
              const SizedBox(height: 8),

        // Time Display Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Hour Tens
            _buildTimeDigit(
              text: hh[0],
              position: _CursorPosition.hourTens,
            ),
            // Hour Ones
            _buildTimeDigit(
              text: hh[1],
              position: _CursorPosition.hourOnes,
            ),
            Text(":", style: textStyle),
            // Minute Tens
            _buildTimeDigit(
              text: mm[0],
              position: _CursorPosition.minuteTens,
            ),
            // Minute Ones
            _buildTimeDigit(
              text: mm[1],
              position: _CursorPosition.minuteOnes,
            ),
            // AM/PM text if 12h
            if (!widget.use24hFormat)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  amPmText,
                  style: textTheme.displayMedium
                      ?.copyWith(color: colorScheme.onSurface, height:1.2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Numpad
        SizedBox(
          width: originalWidth * 0.76,
          height: originalWidth * 1.05,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              if (index < 9) {
                // Digits 1..9
                final digit = (index + 1).toString();
                return _buildNumpadButton(
                  label: digit,
                  onTap: () => _onDigitInput(index + 1),
                );
              } else if (index == 9) {
                // "00"
                return _buildNumpadButton(
    label: "00",
    onTap: () {
      // CHANGES: Press '0' twice in a row.
      if (_cursorPosition != null) {
        _onDigitInput(0); // first zero
      }
      // If the first zero did not disable the cursor, press zero again
      if (_cursorPosition != null) {
        _onDigitInput(0); // second zero
      }
    },
  );              } else if (index == 10) {
                // "0"
                return _buildNumpadButton(
                  label: "0",
                  onTap: () => _onDigitInput(0),
                );
              } else {
                // Toggle AM/PM if 12h mode
                return _buildNumpadButton(
                  label: widget.use24hFormat
                      ? '' 
                      : (_isAm ? 'PM' : 'AM'),
                  onTap: widget.use24hFormat ? null : _onToggleAmPm,
                  isHighlighted: true,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  /// Builds a single time digit (hourTens, hourOnes, minuteTens, minuteOnes).
  /// If it's selected, we wrap in a FadeTransition so it blinks.
  Widget _buildTimeDigit({
    required String text,
    required _CursorPosition position,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSelected = (_cursorPosition == position);
    final textStyle = textTheme.displayLarge
        ?.copyWith(color: colorScheme.onSurface, height: 1, fontSize: 48);

    return GestureDetector(
      onTap: () => _onDigitTap(position),
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 2),
        child: isSelected
            ? FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  text,
                  style: textStyle,)
              )
            : Text(
                text,
                style: textStyle,
              ),
      ),
    );
  }

  /// Builds a numpad button (digits or AM/PM toggle).
  /// Disables if there's no cursor, unless it's the AM/PM toggle.
  Widget _buildNumpadButton({
    String? label,
    VoidCallback? onTap,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isAmPmToggle = (label == 'AM' || label == 'PM');
    final isEnabled = (onTap != null) &&
        (_cursorPosition != null || isAmPmToggle);

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          color: isEnabled
              ? (isHighlighted
                  ? colorScheme.primary.withOpacity(0.2)
                  : colorScheme.onSurface.withOpacity(0.1))
              : colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label ?? '',
            style: textTheme.titleMedium?.copyWith(
              color: isEnabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
