import 'dart:convert';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:flutter/material.dart';

enum FileItemType {
  audio,
  image,
  video,
  other,
  directory,
}

class FileItem extends ListItem {
  final int _id;
  final String name;
  String _uri;
  final bool _isDeletable;

  set uri(String value) {
    _uri = value;
  }

  String get uri => _uri;
  @override
  int get id => _id;
  @override
  bool get isDeletable => _isDeletable;

  FileItem(this.name, this._uri, {isDeletable = true})
      : _id = UniqueKey().hashCode,
        _isDeletable = isDeletable;

  @override
  FileItem.fromJson(Json json)
      : _id = json != null
            ? json['id'] ?? UniqueKey().hashCode
            : UniqueKey().hashCode,
        name = json != null ? json['title'] ?? 'Unknown' : 'Unknown',
        _uri = json != null ? json['uri'] ?? '' : '',
        _isDeletable = json != null ? json['isDeletable'] ?? true : true;

  @override
  Json toJson() => {
        'id': _id,
        'title': name,
        'uri': _uri,
        'isDeletable': _isDeletable,
      };

  @override
  String toString() {
    return json.encode(toJson());
  }

  @override
  copy() {
    return FileItem(name, _uri, isDeletable: _isDeletable);
  }
}
