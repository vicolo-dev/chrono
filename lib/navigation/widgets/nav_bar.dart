// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection' show Queue;
import 'dart:math' as math;

import 'package:clock_app/navigation/widgets/nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

/// Defines the layout and behavior of a [BottomNavBar].
///
/// For a sample on how to use these, please see [BottomNavBar].
/// See also:
///
///  * [BottomNavBar]
///  * [BottomNavBarItem]
///  * <https://material.io/design/components/bottom-navigation.html#specs>
enum BottomNavBarType {
  /// The [BottomNavBar]'s [BottomNavBarItem]s have fixed width.
  fixed,

  /// The location and size of the [BottomNavBar] [BottomNavBarItem]s
  /// animate and labels fade in when they are tapped.
  shifting,
}

/// Refines the layout of a [BottomNavBar] when the enclosing
/// [MediaQueryData.orientation] is [Orientation.landscape].
enum BottomNavBarLandscapeLayout {
  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced and spread out across the available width. Each
  /// item's label and icon are arranged in a column.
  spread,

  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced in a row but only consume as much width as they
  /// would in portrait orientation. The row of items is centered within
  /// the available width. Each item's label and icon are arranged
  /// in a column.
  centered,

  /// If the enclosing [MediaQueryData.orientation] is
  /// [Orientation.landscape] then the navigation bar's items are
  /// evenly spaced and each item's icon and label are lined up in a
  /// row instead of a column.
  linear,
}

/// A material widget that's displayed at the bottom of an app for selecting
/// among a small number of views, typically between three and five.
///
/// The bottom navigation bar consists of multiple items in the form of
/// text labels, icons, or both, laid out on top of a piece of material. It
/// provides quick navigation between the top-level views of an app. For larger
/// screens, side navigation may be a better fit.
///
/// A bottom navigation bar is usually used in conjunction with a [Scaffold],
/// where it is provided as the [Scaffold.BottomNavBar] argument.
///
/// The bottom navigation bar's [type] changes how its [items] are displayed.
/// If not specified, then it's automatically set to
/// [BottomNavBarType.fixed] when there are less than four items, and
/// [BottomNavBarType.shifting] otherwise.
///
/// The length of [items] must be at least two and each item's icon and title/label
/// must not be null.
///
///  * [BottomNavBarType.fixed], the default when there are less than
///    four [items]. The selected item is rendered with the
///    [selectedItemColor] if it's non-null, otherwise the theme's
///    [ColorScheme.primary] color is used for [Brightness.light] themes
///    and [ColorScheme.secondary] for [Brightness.dark] themes.
///    If [backgroundColor] is null, The
///    navigation bar's background color defaults to the [Material] background
///    color, [ThemeData.canvasColor] (essentially opaque white).
///  * [BottomNavBarType.shifting], the default when there are four
///    or more [items]. If [selectedItemColor] is null, all items are rendered
///    in white. The navigation bar's background color is the same as the
///    [BottomNavBarItem.backgroundColor] of the selected item. In this
///    case it's assumed that each item will have a different background color
///    and that background color will contrast well with white.
///
/// {@tool dartpad}
/// This example shows a [BottomNavBar] as it is used within a [Scaffold]
/// widget. The [BottomNavBar] has three [BottomNavBarItem]
/// widgets, which means it defaults to [BottomNavBarType.fixed], and
/// the [currentIndex] is set to index 0. The selected item is
/// amber. The `_onItemTapped` function changes the selected item's index
/// and displays a corresponding message in the center of the [Scaffold].
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows a [BottomNavBar] as it is used within a [Scaffold]
/// widget. The [BottomNavBar] has four [BottomNavBarItem]
/// widgets, which means it defaults to [BottomNavBarType.shifting], and
/// the [currentIndex] is set to index 0. The selected item is amber in color.
/// With each [BottomNavBarItem] widget, backgroundColor property is
/// also defined, which changes the background color of [BottomNavBar],
/// when that item is selected. The `_onItemTapped` function changes the
/// selected item's index and displays a corresponding message in the center of
/// the [Scaffold].
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows [BottomNavBar] used in a [Scaffold] Widget with
/// different interaction patterns. Tapping twice on the first [BottomNavBarItem]
/// uses the [ScrollController] to animate the [ListView] to the top. The second
/// [BottomNavBarItem] shows a Modal Dialog.
///
/// ** See code in examples/api/lib/material/bottom_navigation_bar/bottom_navigation_bar.2.dart **
/// {@end-tool}
/// See also:
///
///  * [BottomNavBarItem]
///  * [Scaffold]
///  * <https://material.io/design/components/bottom-navigation.html>
///  * [NavigationBar], this widget's replacement in Material Design 3.
class BottomNavBar extends StatefulWidget {
  /// Creates a bottom navigation bar which is typically used as a
  /// [Scaffold]'s [Scaffold.BottomNavBar] argument.
  ///
  /// The length of [items] must be at least two and each item's icon and label
  /// must not be null.
  ///
  /// If [type] is null then [BottomNavBarType.fixed] is used when there
  /// are two or three [items], [BottomNavBarType.shifting] otherwise.
  ///
  /// The [iconSize], [selectedFontSize], [unselectedFontSize], and [elevation]
  /// arguments must be non-null and non-negative.
  ///
  /// If [selectedLabelStyle].color and [unselectedLabelStyle].color values
  /// are non-null, they will be used instead of [selectedItemColor] and
  /// [unselectedItemColor].
  ///
  /// If custom [IconThemeData]s are used, you must provide both
  /// [selectedIconTheme] and [unselectedIconTheme], and both
  /// [IconThemeData.color] and [IconThemeData.size] must be set.
  ///
  /// If [useLegacyColorScheme] is set to `false`
  /// [selectedIconTheme] values will be used instead of [iconSize] and [selectedItemColor] for selected icons.
  /// [unselectedIconTheme] values will be used instead of [iconSize] and [unselectedItemColor] for unselected icons.
  ///
  ///
  /// If both [selectedLabelStyle].fontSize and [selectedFontSize] are set,
  /// [selectedLabelStyle].fontSize will be used.
  ///
  /// Only one of [selectedItemColor] and [fixedColor] can be specified. The
  /// former is preferred, [fixedColor] only exists for the sake of
  /// backwards compatibility.
  ///
  /// If [showSelectedLabels] is `null`, [BottomNavBarThemeData.showSelectedLabels]
  /// is used. If [BottomNavBarThemeData.showSelectedLabels]  is null,
  /// then [showSelectedLabels] defaults to `true`.
  ///
  /// If [showUnselectedLabels] is `null`, [BottomNavBarThemeData.showUnselectedLabels]
  /// is used. If [BottomNavBarThemeData.showSelectedLabels] is null,
  /// then [showUnselectedLabels] defaults to `true` when [type] is
  /// [BottomNavBarType.fixed] and `false` when [type] is
  /// [BottomNavBarType.shifting].
  BottomNavBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
    Color? fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    Color? selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
  })  : assert(items.length >= 2),
        assert(
          items.every((BottomNavBarItem item) => item.label != null),
          'Every item must have a non-null label',
        ),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(elevation == null || elevation >= 0.0),
        assert(iconSize >= 0.0),
        assert(
          selectedItemColor == null || fixedColor == null,
          'Either selectedItemColor or fixedColor can be specified, but not both',
        ),
        assert(selectedFontSize >= 0.0),
        assert(unselectedFontSize >= 0.0),
        selectedItemColor = selectedItemColor ?? fixedColor;

  /// Defines the appearance of the button items that are arrayed within the
  /// bottom navigation bar.
  final List<BottomNavBarItem> items;

  /// Called when one of the [items] is tapped.
  ///
  /// The stateful widget that creates the bottom navigation bar needs to keep
  /// track of the index of the selected [BottomNavBarItem] and call
  /// `setState` to rebuild the bottom navigation bar with the new [currentIndex].
  final ValueChanged<int>? onTap;

  /// The index into [items] for the current active [BottomNavBarItem].
  final int currentIndex;

  /// The z-coordinate of this [BottomNavBar].
  ///
  /// If null, defaults to `8.0`.
  ///
  /// {@macro flutter.material.material.elevation}
  final double? elevation;

  /// Defines the layout and behavior of a [BottomNavBar].
  ///
  /// See documentation for [BottomNavBarType] for information on the
  /// meaning of different types.
  final BottomNavBarType? type;

  /// The value of [selectedItemColor].
  ///
  /// This getter only exists for backwards compatibility, the
  /// [selectedItemColor] property is preferred.
  Color? get fixedColor => selectedItemColor;

  /// The color of the [BottomNavBar] itself.
  ///
  /// If [type] is [BottomNavBarType.shifting] and the
  /// [items] have [BottomNavBarItem.backgroundColor] set, the [items]'
  /// backgroundColor will splash and overwrite this color.
  final Color? backgroundColor;

  /// The size of all of the [BottomNavBarItem] icons.
  ///
  /// See [BottomNavBarItem.icon] for more information.
  final double iconSize;

  /// The color of the selected [BottomNavBarItem.icon] and
  /// [BottomNavBarItem.label].
  ///
  /// If null then the [ThemeData.primaryColor] is used.
  final Color? selectedItemColor;

  /// The color of the unselected [BottomNavBarItem.icon] and
  /// [BottomNavBarItem.label]s.
  ///
  /// If null then the [ThemeData.unselectedWidgetColor]'s color is used.
  final Color? unselectedItemColor;

  /// The size, opacity, and color of the icon in the currently selected
  /// [BottomNavBarItem.icon].
  ///
  /// If this is not provided, the size will default to [iconSize], the color
  /// will default to [selectedItemColor].
  ///
  /// It this field is provided, it must contain non-null [IconThemeData.size]
  /// and [IconThemeData.color] properties. Also, if this field is supplied,
  /// [unselectedIconTheme] must be provided.
  final IconThemeData? selectedIconTheme;

  /// The size, opacity, and color of the icon in the currently unselected
  /// [BottomNavBarItem.icon]s.
  ///
  /// If this is not provided, the size will default to [iconSize], the color
  /// will default to [unselectedItemColor].
  ///
  /// It this field is provided, it must contain non-null [IconThemeData.size]
  /// and [IconThemeData.color] properties. Also, if this field is supplied,
  /// [selectedIconTheme] must be provided.
  final IconThemeData? unselectedIconTheme;

  /// The [TextStyle] of the [BottomNavBarItem] labels when they are
  /// selected.
  final TextStyle? selectedLabelStyle;

  /// The [TextStyle] of the [BottomNavBarItem] labels when they are not
  /// selected.
  final TextStyle? unselectedLabelStyle;

  /// The font size of the [BottomNavBarItem] labels when they are selected.
  ///
  /// If [TextStyle.fontSize] of [selectedLabelStyle] is non-null, it will be
  /// used instead of this.
  ///
  /// Defaults to `14.0`.
  final double selectedFontSize;

  /// The font size of the [BottomNavBarItem] labels when they are not
  /// selected.
  ///
  /// If [TextStyle.fontSize] of [unselectedLabelStyle] is non-null, it will be
  /// used instead of this.
  ///
  /// Defaults to `12.0`.
  final double unselectedFontSize;

  /// Whether the labels are shown for the unselected [BottomNavBarItem]s.
  final bool? showUnselectedLabels;

  /// Whether the labels are shown for the selected [BottomNavBarItem].
  final bool? showSelectedLabels;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// items.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///
  /// If null, then the value of [BottomNavBarThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The arrangement of the bar's [items] when the enclosing
  /// [MediaQueryData.orientation] is [Orientation.landscape].
  ///
  /// The following alternatives are supported:
  ///
  /// * [BottomNavBarLandscapeLayout.spread] - the items are
  ///   evenly spaced and spread out across the available width. Each
  ///   item's label and icon are arranged in a column.
  /// * [BottomNavBarLandscapeLayout.centered] - the items are
  ///   evenly spaced in a row but only consume as much width as they
  ///   would in portrait orientation. The row of items is centered within
  ///   the available width. Each item's label and icon are arranged
  ///   in a column.
  /// * [BottomNavBarLandscapeLayout.linear] - the items are
  ///   evenly spaced and each item's icon and label are lined up in a
  ///   row instead of a column.
  ///
  /// If this property is null, then the value of the enclosing
  /// [BottomNavBarThemeData.landscapeLayout is used. If that
  /// property is also null, then
  /// [BottomNavBarLandscapeLayout.spread] is used.
  ///
  /// This property is null by default.
  ///
  /// See also:
  ///
  ///  * [ThemeData.BottomNavBarTheme] - which can be used to specify
  ///    bottom navigation bar defaults for an entire application.
  ///  * [BottomNavBarTheme] - which can be used to specify
  ///    bottom navigation bar defaults for a widget subtree.
  ///  * [MediaQuery.of] - which can be used to determine the current
  ///    orientation.
  final BottomNavBarLandscapeLayout? landscapeLayout;

  /// This flag is controlling how [BottomNavBar] is going to use
  /// the colors provided by the [selectedIconTheme], [unselectedIconTheme],
  /// [selectedItemColor], [unselectedItemColor].
  /// The default value is `true` as the new theming logic is a breaking change.
  /// To opt-in the new theming logic set the flag to `false`
  final bool useLegacyColorScheme;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

// This represents a single tile in the bottom navigation bar. It is intended
// to go into a flex container.
class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
    this.type,
    this.item,
    this.animation,
    this.iconSize, {
    this.onTap,
    this.labelColorTween,
    this.iconColorTween,
    this.flex,
    this.selected = false,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
    this.indexLabel,
    required this.mouseCursor,
    required this.enableFeedback,
    required this.layout,
  });

  final BottomNavBarType type;
  final BottomNavBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback? onTap;
  final ColorTween? labelColorTween;
  final ColorTween? iconColorTween;
  final double? flex;
  final bool selected;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final String? indexLabel;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final MouseCursor mouseCursor;
  final bool enableFeedback;
  final BottomNavBarLandscapeLayout layout;

  @override
  Widget build(BuildContext context) {
    // In order to use the flex container to grow the tile during animation, we
    // need to divide the changes in flex allotment into smaller pieces to
    // produce smooth animation. We do this by multiplying the flex value
    // (which is an integer) by a large number.
    final int size;

    final double selectedFontSize = selectedLabelStyle.fontSize!;

    final double selectedIconSize = selectedIconTheme?.size ?? iconSize;
    final double unselectedIconSize = unselectedIconTheme?.size ?? iconSize;

    // The amount that the selected icon is bigger than the unselected icons,
    // (or zero if the selected icon is not bigger than the unselected icons).
    final double selectedIconDiff =
        math.max(selectedIconSize - unselectedIconSize, 0);
    // The amount that the unselected icons are bigger than the selected icon,
    // (or zero if the unselected icons are not any bigger than the selected icon).
    final double unselectedIconDiff =
        math.max(unselectedIconSize - selectedIconSize, 0);

    // The effective tool tip message to be shown on the BottomNavBarItem.
    final String? effectiveTooltip = item.tooltip == '' ? null : item.tooltip;

    // Defines the padding for the animating icons + labels.
    //
    // The animations go from "Unselected":
    // =======
    // |      <-- Padding equal to the text height + 1/2 selectedIconDiff.
    // |  ☆
    // | text <-- Invisible text + padding equal to 1/2 selectedIconDiff.
    // =======
    //
    // To "Selected":
    //
    // =======
    // |      <-- Padding equal to 1/2 text height + 1/2 unselectedIconDiff.
    // |  ☆
    // | text
    // |      <-- Padding equal to 1/2 text height + 1/2 unselectedIconDiff.
    // =======
    double bottomPadding;
    double topPadding;
    if (showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else if (!showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else {
      bottomPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    }

    switch (type) {
      case BottomNavBarType.fixed:
        size = 1;
        break;
      case BottomNavBarType.shifting:
        size = (flex! * 1000.0).round();
        break;
    }

    Widget result = InkResponse(
      onTap: onTap,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      child: Padding(
        padding:
            EdgeInsets.only(top: topPadding + 8, bottom: bottomPadding + 8),
        child: _Tile(
          layout: layout,
          icon: _TileIcon(
            colorTween: iconColorTween!,
            animation: animation,
            iconSize: iconSize,
            selected: selected,
            item: item,
            selectedIconTheme: selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme,
          ),
          label: _Label(
            colorTween: labelColorTween!,
            animation: animation,
            item: item,
            selectedLabelStyle: selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            showSelectedLabels: showSelectedLabels,
            showUnselectedLabels: showUnselectedLabels,
          ),
        ),
      ),
    );

    if (effectiveTooltip != null) {
      result = Tooltip(
        message: effectiveTooltip,
        preferBelow: false,
        verticalOffset: selectedIconSize + selectedFontSize,
        excludeFromSemantics: true,
        child: result,
      );
    }

    result = Semantics(
      selected: selected,
      container: true,
      child: Stack(
        children: <Widget>[
          result,
          Semantics(
            label: indexLabel,
          ),
        ],
      ),
    );

    return Expanded(
      flex: size,
      child: result,
    );
  }
}

// If the orientation is landscape and layout is
// BottomNavBarLandscapeLayout.linear then return a
// icon-space-label row, where space is 8 pixels. Otherwise return a
// icon-label column.
class _Tile extends StatelessWidget {
  const _Tile({required this.layout, required this.icon, required this.label});

  final BottomNavBarLandscapeLayout layout;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    if (data.orientation == Orientation.landscape &&
        layout == BottomNavBarLandscapeLayout.linear) {
      return Align(
        heightFactor: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, label],
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    required this.colorTween,
    required this.animation,
    required this.iconSize,
    required this.selected,
    required this.item,
    required this.selectedIconTheme,
    required this.unselectedIconTheme,
  });

  final ColorTween colorTween;
  final Animation<double> animation;
  final double iconSize;
  final bool selected;
  final BottomNavBarItem item;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = colorTween.evaluate(animation);
    final IconThemeData defaultIconTheme = IconThemeData(
      color: iconColor,
      size: iconSize,
    );
    final IconThemeData iconThemeData = IconThemeData.lerp(
      defaultIconTheme.merge(unselectedIconTheme),
      defaultIconTheme.merge(selectedIconTheme),
      animation.value,
    );

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: IconTheme(
        data: iconThemeData,
        child: selected ? item.activeIcon : item.icon,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.colorTween,
    required this.animation,
    required this.item,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
  });

  final ColorTween colorTween;
  final Animation<double> animation;
  final BottomNavBarItem item;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  @override
  Widget build(BuildContext context) {
    final double? selectedFontSize = selectedLabelStyle.fontSize;
    final double? unselectedFontSize = unselectedLabelStyle.fontSize;

    final TextStyle customStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      animation.value,
    )!;
    Widget text = DefaultTextStyle.merge(
      style: customStyle.copyWith(
        fontSize: selectedFontSize,
        color: colorTween.evaluate(animation),
      ),
      // The font size should grow here when active, but because of the way
      // font rendering works, it doesn't grow smoothly if we just animate
      // the font size, so we use a transform instead.
      child: Transform(
        transform: Matrix4.diagonal3(
          Vector3.all(
            Tween<double>(
              begin: unselectedFontSize! / selectedFontSize!,
              end: 1.0,
            ).evaluate(animation),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Text(item.label!),
      ),
    );

    if (!showUnselectedLabels && !showSelectedLabels) {
      // Never show any labels.
      text = Visibility.maintain(
        visible: false,
        child: text,
      );
    } else if (!showUnselectedLabels) {
      // Fade selected labels in.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: animation,
        child: text,
      );
    } else if (!showSelectedLabels) {
      // Fade selected labels out.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
        child: text,
      );
    }

    text = Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Container(child: text),
    );

    if (item.label != null) {
      // Do not grow text in bottom navigation bar when we can show a tooltip
      // instead.
      final MediaQueryData mediaQueryData = MediaQuery.of(context);
      text = MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: math.min(1.0, mediaQueryData.textScaleFactor),
        ),
        child: text,
      );
    }

    return text;
  }
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = <AnimationController>[];
  late List<CurvedAnimation> _animations;

  // A queue of color splashes currently being animated.
  final Queue<_Circle> _circles = Queue<_Circle>();

  // Last splash circle's color, and the final color of the control after
  // animation is complete.
  Color? _backgroundColor;

  static final Animatable<double> _flexTween =
      Tween<double>(begin: 1.0, end: 1.5);

  void _resetState() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    for (final _Circle circle in _circles) {
      circle.dispose();
    }
    _circles.clear();

    _controllers =
        List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations =
        List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  // Computes the default value for the [type] parameter.
  //
  // If type is provided, it is returned. Next, if the bottom navigation bar
  // theme provides a type, it is used. Finally, the default behavior will be
  // [BottomNavBarType.fixed] for 3 or fewer items, and
  // [BottomNavBarType.shifting] is used for 4+ items.
  BottomNavBarType get _effectiveType {
    return BottomNavBarType.fixed;
  }

  // Computes the default value for the [showUnselected] parameter.
  //
  // Unselected labels are shown by default for [BottomNavBarType.fixed],
  // and hidden by default for [BottomNavBarType.shifting].
  bool get _defaultShowUnselected {
    switch (_effectiveType) {
      case BottomNavBarType.shifting:
        return false;
      case BottomNavBarType.fixed:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animated.
    });
  }

  @override
  void dispose() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    for (final _Circle circle in _circles) {
      circle.dispose();
    }
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) =>
      _flexTween.evaluate(animation);

  void _pushCircle(int index) {
    if (widget.items[index].backgroundColor != null) {
      _circles.add(
        _Circle(
          state: this,
          index: index,
          color: widget.items[index].backgroundColor!,
          vsync: this,
        )..controller.addStatusListener(
            (AnimationStatus status) {
              switch (status) {
                case AnimationStatus.completed:
                  setState(() {
                    final _Circle circle = _circles.removeFirst();
                    _backgroundColor = circle.color;
                    circle.dispose();
                  });
                  break;
                case AnimationStatus.dismissed:
                case AnimationStatus.forward:
                case AnimationStatus.reverse:
                  break;
              }
            },
          ),
      );
    }
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // No animated segue if the length of the items list changes.
    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      switch (_effectiveType) {
        case BottomNavBarType.fixed:
          break;
        case BottomNavBarType.shifting:
          _pushCircle(widget.currentIndex);
          break;
      }
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    } else {
      if (_backgroundColor !=
          widget.items[widget.currentIndex].backgroundColor) {
        _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
      }
    }
  }

  // If the given [TextStyle] has a non-null `fontSize`, it should be used.
  // Otherwise, the [selectedFontSize] parameter should be used.
  static TextStyle _effectiveTextStyle(TextStyle? textStyle, double fontSize) {
    textStyle ??= const TextStyle();
    // Prefer the font size on textStyle if present.
    return textStyle.fontSize == null
        ? textStyle.copyWith(fontSize: fontSize)
        : textStyle;
  }

  // If [IconThemeData] is provided, it should be used.
  // Otherwise, the [IconThemeData]'s color should be selectedItemColor
  // or unselectedItemColor.
  static IconThemeData _effectiveIconTheme(
      IconThemeData? iconTheme, Color? itemColor) {
    // Prefer the iconTheme over itemColor if present.
    return iconTheme ?? IconThemeData(color: itemColor);
  }

  List<Widget> _createTiles(BottomNavBarLandscapeLayout layout) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final ThemeData themeData = Theme.of(context);
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);

    final Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.colorScheme.primary;
        break;
      case Brightness.dark:
        themeColor = themeData.colorScheme.secondary;
        break;
    }

    final TextStyle effectiveSelectedLabelStyle = _effectiveTextStyle(
      widget.selectedLabelStyle ?? bottomTheme.selectedLabelStyle,
      widget.selectedFontSize,
    );

    final TextStyle effectiveUnselectedLabelStyle = _effectiveTextStyle(
      widget.unselectedLabelStyle ?? bottomTheme.unselectedLabelStyle,
      widget.unselectedFontSize,
    );

    final IconThemeData effectiveSelectedIconTheme = _effectiveIconTheme(
        widget.selectedIconTheme ?? bottomTheme.selectedIconTheme,
        widget.selectedItemColor ??
            bottomTheme.selectedItemColor ??
            themeColor);

    final IconThemeData effectiveUnselectedIconTheme = _effectiveIconTheme(
        widget.unselectedIconTheme ?? bottomTheme.unselectedIconTheme,
        widget.unselectedItemColor ??
            bottomTheme.unselectedItemColor ??
            themeData.unselectedWidgetColor);

    final ColorTween colorTween;
    switch (_effectiveType) {
      case BottomNavBarType.fixed:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavBarType.shifting:
        colorTween = ColorTween(
          begin: widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeData.colorScheme.surface,
        );
        break;
    }

    final ColorTween labelColorTween;
    switch (_effectiveType) {
      case BottomNavBarType.fixed:
        labelColorTween = ColorTween(
          begin: effectiveUnselectedLabelStyle.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: effectiveSelectedLabelStyle.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavBarType.shifting:
        labelColorTween = ColorTween(
          begin: effectiveUnselectedLabelStyle.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: effectiveSelectedLabelStyle.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeColor,
        );
        break;
    }

    final ColorTween iconColorTween;
    switch (_effectiveType) {
      case BottomNavBarType.fixed:
        iconColorTween = ColorTween(
          begin: effectiveSelectedIconTheme.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.unselectedWidgetColor,
          end: effectiveUnselectedIconTheme.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              widget.fixedColor ??
              themeColor,
        );
        break;
      case BottomNavBarType.shifting:
        iconColorTween = ColorTween(
          begin: effectiveUnselectedIconTheme.color ??
              widget.unselectedItemColor ??
              bottomTheme.unselectedItemColor ??
              themeData.colorScheme.surface,
          end: effectiveSelectedIconTheme.color ??
              widget.selectedItemColor ??
              bottomTheme.selectedItemColor ??
              themeColor,
        );
        break;
    }

    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < widget.items.length; i++) {
      final Set<MaterialState> states = <MaterialState>{
        if (i == widget.currentIndex) MaterialState.selected,
      };

      final MouseCursor effectiveMouseCursor =
          MaterialStateProperty.resolveAs<MouseCursor?>(
                  widget.mouseCursor, states) ??
              bottomTheme.mouseCursor?.resolve(states) ??
              MaterialStateMouseCursor.clickable.resolve(states);

      tiles.add(_BottomNavigationTile(
        _effectiveType,
        widget.items[i],
        _animations[i],
        widget.iconSize,
        selectedIconTheme: widget.useLegacyColorScheme
            ? widget.selectedIconTheme ?? bottomTheme.selectedIconTheme
            : effectiveSelectedIconTheme,
        unselectedIconTheme: widget.useLegacyColorScheme
            ? widget.unselectedIconTheme ?? bottomTheme.unselectedIconTheme
            : effectiveUnselectedIconTheme,
        selectedLabelStyle: effectiveSelectedLabelStyle,
        unselectedLabelStyle: effectiveUnselectedLabelStyle,
        enableFeedback:
            widget.enableFeedback ?? bottomTheme.enableFeedback ?? true,
        onTap: () {
          widget.onTap?.call(i);
        },
        labelColorTween:
            widget.useLegacyColorScheme ? colorTween : labelColorTween,
        iconColorTween:
            widget.useLegacyColorScheme ? colorTween : iconColorTween,
        flex: _evaluateFlex(_animations[i]),
        selected: i == widget.currentIndex,
        showSelectedLabels:
            widget.showSelectedLabels ?? bottomTheme.showSelectedLabels ?? true,
        showUnselectedLabels: widget.showUnselectedLabels ??
            bottomTheme.showUnselectedLabels ??
            _defaultShowUnselected,
        indexLabel: localizations.tabLabel(
            tabIndex: i + 1, tabCount: widget.items.length),
        mouseCursor: effectiveMouseCursor,
        layout: layout,
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasOverlay(context));

    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);
    const BottomNavBarLandscapeLayout layout =
        BottomNavBarLandscapeLayout.spread;
    final double additionalBottomPadding =
        MediaQuery.of(context).viewPadding.bottom;

    Color? backgroundColor;
    switch (_effectiveType) {
      case BottomNavBarType.fixed:
        backgroundColor = widget.backgroundColor ?? bottomTheme.backgroundColor;
        break;
      case BottomNavBarType.shifting:
        backgroundColor = _backgroundColor;
        break;
    }

    return Semantics(
      explicitChildNodes: true,
      child: _Bar(
        layout: layout,
        elevation: widget.elevation ?? bottomTheme.elevation ?? 8.0,
        color: backgroundColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
          child: CustomPaint(
            painter: _RadialPainter(
              circles: _circles.toList(),
              textDirection: Directionality.of(context),
            ),
            child: Material(
              // Splashes.
              type: MaterialType.transparency,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8, right: 8, bottom: additionalBottomPadding),
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: DefaultTextStyle.merge(
                    overflow: TextOverflow.ellipsis,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _createTiles(layout),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Optionally center a Material child for landscape layouts when layout is
// BottomNavBarLandscapeLayout.centered
class _Bar extends StatelessWidget {
  const _Bar({
    required this.child,
    required this.layout,
    required this.elevation,
    required this.color,
  });

  final Widget child;
  final BottomNavBarLandscapeLayout layout;
  final double elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    Widget alignedChild = child;
    if (data.orientation == Orientation.landscape &&
        layout == BottomNavBarLandscapeLayout.centered) {
      alignedChild = Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: SizedBox(
          width: data.size.height,
          child: child,
        ),
      );
    }
    return Material(
      elevation: elevation,
      color: color,
      child: alignedChild,
    );
  }
}

// Describes an animating color splash circle.
class _Circle {
  _Circle({
    required this.state,
    required this.index,
    required this.color,
    required TickerProvider vsync,
  }) {
    controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    controller.forward();
  }

  final _BottomNavBarState state;
  final int index;
  final Color color;
  late AnimationController controller;
  late CurvedAnimation animation;

  double get horizontalLeadingOffset {
    double weightSum(Iterable<Animation<double>> animations) {
      // We're adding flex values instead of animation values to produce correct
      // ratios.
      return animations
          .map<double>(state._evaluateFlex)
          .fold<double>(0.0, (double sum, double value) => sum + value);
    }

    final double allWeights = weightSum(state._animations);
    // These weights sum to the start edge of the indexed item.
    final double leadingWeights =
        weightSum(state._animations.sublist(0, index));

    // Add half of its flex value in order to get to the center.
    return (leadingWeights +
            state._evaluateFlex(state._animations[index]) / 2.0) /
        allWeights;
  }

  void dispose() {
    controller.dispose();
  }
}

// Paints the animating color splash circles.
class _RadialPainter extends CustomPainter {
  _RadialPainter({
    required this.circles,
    required this.textDirection,
  });

  final List<_Circle> circles;
  final TextDirection textDirection;

  // Computes the maximum radius attainable such that at least one of the
  // bounding rectangle's corners touches the edge of the circle. Drawing a
  // circle larger than this radius is not needed, since there is no perceivable
  // difference within the cropped rectangle.
  static double _maxRadius(Offset center, Size size) {
    final double maxX = math.max(center.dx, size.width - center.dx);
    final double maxY = math.max(center.dy, size.height - center.dy);
    return math.sqrt(maxX * maxX + maxY * maxY);
  }

  @override
  bool shouldRepaint(_RadialPainter oldPainter) {
    if (textDirection != oldPainter.textDirection) {
      return true;
    }
    if (circles == oldPainter.circles) {
      return false;
    }
    if (circles.length != oldPainter.circles.length) {
      return true;
    }
    for (int i = 0; i < circles.length; i += 1) {
      if (circles[i] != oldPainter.circles[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Circle circle in circles) {
      final Paint paint = Paint()..color = circle.color;
      final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      canvas.clipRect(rect);
      final double leftFraction;
      switch (textDirection) {
        case TextDirection.rtl:
          leftFraction = 1.0 - circle.horizontalLeadingOffset;
          break;
        case TextDirection.ltr:
          leftFraction = circle.horizontalLeadingOffset;
          break;
      }
      final Offset center =
          Offset(leftFraction * size.width, size.height / 2.0);
      final Tween<double> radiusTween = Tween<double>(
        begin: 0.0,
        end: _maxRadius(center, size),
      );
      canvas.drawCircle(
        center,
        radiusTween.transform(circle.animation.value),
        paint,
      );
    }
  }
}
