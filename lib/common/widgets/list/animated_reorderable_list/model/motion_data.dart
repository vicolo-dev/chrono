import 'package:flutter/cupertino.dart';

class MotionData {
  final Offset startOffset;
  final Offset endOffset;
  final bool visible;

  MotionData(
      {this.startOffset = Offset.zero,
      this.endOffset = Offset.zero,
      this.visible = true});

  MotionData copyWith({Offset? startOffset, Offset? endOffset, bool? visible}) {
    return MotionData(
        startOffset: startOffset ?? this.startOffset,
        endOffset: endOffset ?? this.endOffset,
        visible: visible ?? this.visible);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotionData &&
          runtimeType == other.runtimeType &&
          startOffset == other.startOffset &&
          endOffset == other.endOffset;

  @override
  int get hashCode => startOffset.hashCode ^ endOffset.hashCode;
}
