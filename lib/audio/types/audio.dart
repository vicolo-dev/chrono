import 'dart:convert';

import 'package:clock_app/common/types/json.dart';

// class Audio {
//   final String id;
//   final String title;
//   final String uri;

//   const Audio({
//     required this.id,
//     required this.title,
//     required this.uri,
//   });

//   factory Audio.fromJson(Json json) => Audio(
//         id: json != null ? json['id'] ?? '' : '',
//         title: json != null ? json['title'] ?? 'Unknown' : 'Unknown',
//         uri: json != null ? json['uri'] ?? '' : '',
//       );

//   Json toJson() => {
//         'id': id,
//         'title': title,
//         'uri': uri,
//       };

//   factory Audio.fromEncodedJson(String encodedJson) =>
//       Audio.fromJson(json.decode(encodedJson));
//   String toEncodedJson() => json.encode(toJson());
//   @override
//   String toString() {
//     return 'Ringtone{id: $id, title: $title, uri: $uri}';
//   }

//   Audio copyWith({
//     String? id,
//     String? title,
//     String? uri,
//   }) {
//     return Audio(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       uri: uri ?? this.uri,
//     );
//   }
// }
