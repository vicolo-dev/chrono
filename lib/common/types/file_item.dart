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
  final String title;
  final String uri;

  @override
  int get id => _id;

  @override
  bool get isDeletable => true;

  FileItem(
    this.title,
    this.uri,
  ) : _id = UniqueKey().hashCode;

  @override
  FileItem.fromJson(Json json)
      : _id = json != null
            ? json['_id'] ?? UniqueKey().hashCode
            : UniqueKey().hashCode,
        title = json != null ? json['title'] ?? 'Unknown' : 'Unknown',
        uri = json != null ? json['uri'] ?? '' : '';

  @override
  Json toJson() => {
        'id': id,
        'title': title,
        'uri': uri,
      };

  // factory Audio.fromEncodedJson(String encodedJson) =>
  //     Audio.fromJson(json.decode(encodedJson));
  // String toEncodedJson() => json.encode(toJson());
  @override
  String toString() {
    return json.encode(toJson());
  }

  FileItem copyWith({
    String? title,
    String? uri,
  }) {
    return FileItem(
      title ?? this.title,
      uri ?? this.uri,
    );
  }

  @override
  copy() {
    return FileItem(title, uri);
  }
}
