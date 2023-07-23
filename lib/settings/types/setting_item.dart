import 'package:clock_app/settings/types/setting_group.dart';

abstract class SettingItem {
  String name;
  String id;
  SettingGroup? _parent;

  SettingGroup? get parent => _parent;
  set parent(SettingGroup? parent) {
    _parent = parent;
    id = "${_parent?.id}/$name";
  }

  List<SettingGroup> get path {
    List<SettingGroup> path = [];
    SettingGroup? currentParent = parent;
    while (currentParent != null) {
      path.add(currentParent);
      currentParent = currentParent.parent;
    }
    return path.reversed.toList();
  }

  SettingItem(this.name) : id = name;

  SettingItem copy();

  dynamic toJson();

  void fromJson(dynamic value);
}
