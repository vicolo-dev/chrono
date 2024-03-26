import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

enum FabPosition { bottomLeft, bottomRight }

class FAB extends StatefulWidget {
  const FAB({
    super.key,
    this.onPressed,
    this.icon = FluxIcons.add,
    this.index = 0,
    this.bottomPadding = 0,
    this.size = 1,
    this.position = FabPosition.bottomRight,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final int index;
  final double bottomPadding;
  final double size;
  final FabPosition position;

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  late Setting _leftHandedMode;
  late Setting _useMaterialStyle;

  void update(value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _leftHandedMode =
        appSettings.getGroup("Accessibility").getSetting("Left Handed Mode");
        _useMaterialStyle = appSettings.getGroup("Appearance").getGroup("Style").getSetting("Use Material Style");
    _leftHandedMode.addListener(update);
    _useMaterialStyle.addListener(update);
  }

  @override
  void dispose() {
    _leftHandedMode.removeListener(update);
    _useMaterialStyle.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = _leftHandedMode.value
        ? widget.position == FabPosition.bottomRight
            ? FabPosition.bottomLeft
            : FabPosition.bottomRight
        : widget.position;

double bottomPadding = _useMaterialStyle.value ? widget.bottomPadding + 20 : widget.bottomPadding;

    return Positioned(
      bottom: bottomPadding,
      right: position == FabPosition.bottomRight
          ? 16 + (widget.index * 24 * widget.size) + widget.index * 36
          : null,
      left: position == FabPosition.bottomLeft
          ? 16 + (widget.index * 24 * widget.size) + widget.index * 36
          : null,
      child: CardContainer(
        elevationMultiplier: 2,
        color: Theme.of(context).colorScheme.primary,
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24 * widget.size,
          ),
        ),
      ),
    );
  }
}
