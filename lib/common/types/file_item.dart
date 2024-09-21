import 'dart:convert';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/id.dart';

enum FileItemType {
  audio,
  image,
  video,
  text,
  other,
  directory,
}

class FileItem extends ListItem {
  int _id;
  String name;
  FileItemType _type;
  String _uri;
  bool _isDeletable;

  set uri(String value) {
    _uri = value;
  }

  String get uri => _uri;
  @override
  int get id => _id;
  FileItemType get type => _type;
  @override
  bool get isDeletable => _isDeletable;

  FileItem(this.name, this._uri, this._type, {isDeletable = true})
      : _id = getId(),
        _isDeletable = isDeletable;

  @override
  FileItem.fromJson(Json json)
      : _id = json != null
            ? json['id'] ?? getId()
            : getId(),
        _type = json != null
            ? json['type'] != null
                ? FileItemType.values
                    .firstWhere((e) => e.toString() == json['type'])
                : FileItemType.audio
            : FileItemType.audio,
        name = json != null ? json['title'] ?? 'Unknown' : 'Unknown',
        _uri = json != null ? json['uri'] ?? '' : '',
        _isDeletable = json != null ? json['isDeletable'] ?? true : true;

  @override
  Json toJson() => {
        'id': _id,
        'title': name,
        'uri': _uri,
        'isDeletable': _isDeletable,
        'type': _type.toString(),
      };

  @override
  String toString() {
    return json.encode(toJson());
  }

  @override
  copy() {
    return FileItem(name, _uri, _type, isDeletable: _isDeletable);
  }

  @override
  void copyFrom(other) {
    _id = other.id;
    name = other.name;
    _uri = other.uri;
    _isDeletable = other.isDeletable;
    _type = other.type;
  }
}
