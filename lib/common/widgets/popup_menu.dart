// import 'dart:core';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:popup_menu/src/grid_menu_layout.dart';
// import 'package:popup_menu/src/list_menu_layout.dart';
// import 'package:popup_menu/src/menu_config.dart';
// import 'package:popup_menu/src/menu_layout.dart';
// import 'package:popup_menu/src/triangle_painter.dart';
// import 'package:popup_menu/src/utils.dart';

// enum MenuType {
//   /// 格子
//   grid,

//   /// 单列
//   list
// }

// typedef MenuClickCallback = void Function(MenuItemProvider item);

// class CustomPopupMenu {
//   OverlayEntry? _entry;
//   late List<MenuItemProvider> items;

//   /// callback
//   final VoidCallback? onDismiss;
//   final MenuClickCallback? onClickMenu;
//   final VoidCallback? onShow;

//   /// Cannot be null
//   BuildContext context;

//   /// It's showing or not.
//   bool _isShow = false;
//   bool get isShow => _isShow;

//   final MenuConfig config;
//   final Size _screenSize = window.physicalSize / window.devicePixelRatio;

//   CustomPopupMenu({
//     required this.context,
//     required this.items,
//     this.config = const MenuConfig(),
//     this.onClickMenu,
//     this.onDismiss,
//     this.onShow,
//   });

//   MenuLayout? menuLayout;

//   void show({
//     Rect? rect,
//     GlobalKey? widgetKey,
//   }) {
//     assert(rect != null || widgetKey != null,
//         "'rect' and 'key' can't be both null");

//     final attachRect = rect ?? getWidgetGlobalRect(widgetKey!);

//     if (config.type == MenuType.grid) {
//       menuLayout = GridMenuLayout(
//         config: config,
//         items: items,
//         onDismiss: dismiss,
//         context: context,
//         onClickMenu: onClickMenu,
//       );
//     } else if (config.type == MenuType.list) {
//       menuLayout = ListMenuLayout(
//         config: config,
//         items: items,
//         onDismiss: dismiss,
//         context: context,
//         onClickMenu: onClickMenu,
//       );
//     }

//     _LayoutP layoutp = _calculateOffset(
//       context,
//       attachRect,
//       menuLayout!.width,
//       menuLayout!.height,
//     );

//     _entry = OverlayEntry(builder: (context) {
//       return build(layoutp, menuLayout!);
//     });

//     Overlay.of(context)!.insert(_entry!);
//     _isShow = true;
//     onShow?.call();
//   }

//   Widget build(_LayoutP layoutp, MenuLayout menu) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         dismiss();
//       },
//       onVerticalDragStart: (DragStartDetails details) {
//         dismiss();
//       },
//       onHorizontalDragStart: (DragStartDetails details) {
//         dismiss();
//       },
//       child: Material(
//           color: Colors.transparent,
//           elevation: 2,
//           child: Stack(
//             children: <Widget>[
//               // triangle arrow
//               Positioned(
//                 left: layoutp.attachRect.left +
//                     layoutp.attachRect.width / 2.0 -
//                     7.5,
//                 top: layoutp.isDown
//                     ? layoutp.offset.dy + layoutp.height
//                     : layoutp.offset.dy - config.arrowHeight,
//                 child: CustomPaint(
//                   size: Size(15.0, config.arrowHeight),
//                   painter: TrianglePainter(
//                       isDown: layoutp.isDown, color: config.backgroundColor),
//                 ),
//               ),
//               // menu content
//               Positioned(
//                 left: layoutp.offset.dx,
//                 top: layoutp.offset.dy,
//                 child: menu.build(),
//               )
//             ],
//           )),
//     );
//   }

//   /// 计算布局位置
//   _LayoutP _calculateOffset(
//     BuildContext context,
//     Rect attachRect,
//     double contentWidth,
//     double contentHeight,
//   ) {
//     double dx = attachRect.left + attachRect.width / 2.0 - contentWidth / 2.0;
//     if (dx < 10.0) {
//       dx = 10.0;
//     }

//     if (dx + contentWidth > _screenSize.width && dx > 10.0) {
//       double tempDx = _screenSize.width - contentWidth - 10;
//       if (tempDx > 10) {
//         dx = tempDx;
//       }
//     }

//     double dy = attachRect.top - contentHeight;
//     bool isDown = false;
//     if (dy <= MediaQuery.of(context).padding.top + 10) {
//       // The have not enough space above, show menu under the widget.
//       dy = config.arrowHeight + attachRect.height + attachRect.top;
//       isDown = false;
//     } else {
//       dy -= config.arrowHeight;
//       isDown = true;
//     }

//     return _LayoutP(
//       width: contentWidth,
//       height: contentHeight,
//       attachRect: attachRect,
//       offset: Offset(dx, dy),
//       isDown: isDown,
//     );
//   }

//   void dismiss() {
//     if (!_isShow) {
//       // Remove method should only be called once
//       return;
//     }

//     _entry?.remove();
//     _isShow = false;
//     onDismiss?.call();
//   }
// }

// class _LayoutP {
//   double width;
//   double height;
//   Offset offset;
//   Rect attachRect;
//   bool isDown;

//   _LayoutP({
//     required this.width,
//     required this.height,
//     required this.offset,
//     required this.attachRect,
//     required this.isDown,
//   });
// }
