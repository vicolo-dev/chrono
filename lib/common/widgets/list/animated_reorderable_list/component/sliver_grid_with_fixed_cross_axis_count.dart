import 'dart:math';
import 'package:flutter/rendering.dart';

class SliverGridWithCustomGeometryLayout extends SliverGridRegularTileLayout {
  final SliverGridGeometry Function(
      int index, SliverGridRegularTileLayout layout) geometryBuilder;

  const SliverGridWithCustomGeometryLayout({
    required this.geometryBuilder,
    required int crossAxisCount,
    required double mainAxisStride,
    required double crossAxisStride,
    required double childMainAxisExtent,
    required double childCrossAxisExtent,
    required bool reverseCrossAxis,
  })  : assert(crossAxisCount > 0),
        assert(mainAxisStride >= 0),
        assert(crossAxisStride >= 0),
        assert(childMainAxisExtent >= 0),
        assert(childCrossAxisExtent >= 0),
        super(
            crossAxisCount: crossAxisCount,
            mainAxisStride: mainAxisStride,
            crossAxisStride: crossAxisStride,
            childMainAxisExtent: childMainAxisExtent,
            childCrossAxisExtent: childCrossAxisExtent,
            reverseCrossAxis: reverseCrossAxis);

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return geometryBuilder(index, this);
  }
}

/// Creates grid layouts with a fixed number of tiles in the cross axis.
///
/// For example, if the grid is vertical, this delegate will create a layout
/// with a fixed number of columns. If the grid is horizontal, this delegate
/// will create a layout with a fixed number of rows.
///
/// This delegate creates grids with equally sized and spaced tiles.

class SliverReorderableGridDelegateWithFixedCrossAxisCount
    extends SliverGridDelegateWithFixedCrossAxisCount {
  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// The extent of each tile in the main axis. If provided it would define the
  /// logical pixels taken by each tile in the main-axis.
  ///
  /// If null, [childAspectRatio] is used instead.
  final double? mainAxisExtent;

  double childCrossAxisExtent = 0.0;
  double childMainAxisExtent = 0.0;

  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis.
  ///
  /// The `mainAxisSpacing`, `mainAxisExtent` and `crossAxisSpacing` arguments
  /// must not be negative. The `crossAxisCount` and `childAspectRatio`
  /// arguments must be greater than zero.

  SliverReorderableGridDelegateWithFixedCrossAxisCount({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
  })  : assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0),
        super(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        );

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0);
    assert(crossAxisSpacing >= 0);
    assert(childAspectRatio > 0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final usableCrossAxisCount = max(0.0,
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1));

    childCrossAxisExtent = usableCrossAxisCount / crossAxisCount;
    childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return SliverGridWithCustomGeometryLayout(
        geometryBuilder: (index, layout) {
          return SliverGridGeometry(
              scrollOffset: (index ~/ crossAxisCount) * layout.mainAxisStride,
              crossAxisOffset: _getOffsetFromStartInCrossAxis(index, layout),
              mainAxisExtent: childMainAxisExtent,
              crossAxisExtent: childCrossAxisExtent);
        },
        crossAxisCount: crossAxisCount,
        mainAxisStride: childMainAxisExtent + mainAxisSpacing,
        crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
        childMainAxisExtent: childMainAxisExtent,
        childCrossAxisExtent: childCrossAxisExtent,
        reverseCrossAxis:
            axisDirectionIsReversed(constraints.crossAxisDirection));
  }

  Offset getOffset(int index, Offset currentOffset) {
    final int col = index % crossAxisCount;
    final crossAxisStart = crossAxisSpacing;

    if (col == crossAxisCount - 1) {
      return Offset(crossAxisStart, currentOffset.dy + childMainAxisExtent);
    } else {
      return Offset(currentOffset.dx + childCrossAxisExtent, currentOffset.dy);
    }
  }

  double _getOffsetFromStartInCrossAxis(
    int index,
    SliverGridRegularTileLayout layout,
  ) {
    final crossAxisStart = (index % crossAxisCount) * layout.crossAxisStride;

    if (layout.reverseCrossAxis) {
      return crossAxisCount * layout.crossAxisStride -
          crossAxisStart -
          layout.childCrossAxisExtent -
          (layout.crossAxisStride - layout.childCrossAxisExtent);
    }
    return crossAxisStart;
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithFixedCrossAxisCount oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio ||
        oldDelegate.mainAxisExtent != mainAxisExtent;
  }
}
