import 'dart:async';
import 'dart:io';

import 'package:clock_app/developer/logic/logger.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

/// Android-specific. uses a platform channel which calls Scoped Storage APIs
/// so that we can list directory contents and read files from a selected folder
class AndroidFile {
  String uri;
  String name;
  int size;
  DateTime modifiedDate;

  AndroidFile(
      {required this.uri,
      required this.name,
      required this.size,
      required this.modifiedDate});
  AndroidFile.fromFile(File file)
      : this(
            uri: file.path,
            name: file.path.split('/').last,
            size: file.lengthSync(),
            modifiedDate: file.lastModifiedSync());

  static const methodChannel = MethodChannel('com.vicolo.chrono/documents');

  Stream<List<int>> openRead() async* {
    const int chunkSize = 1024 * 1024; // 1MB
    int offset = 0;
    bool moreData = true;

    while (moreData) {
      try {
        final Map<String, dynamic> arguments = {
          'uri': uri,
          'offset': offset,
          'chunkSize': chunkSize,
        };
        final List<int>? chunk =
            await methodChannel.invokeMethod('getFileChunk', arguments);
        if (chunk == null || chunk.isEmpty) {
          moreData = false;
        } else {
          yield Uint8List.fromList(chunk);
          offset += chunk.length;
        }
      } on PlatformException catch (e) {
        logger.e("Failed to get file chunk: ${e.message}");
        moreData = false;
      }
    }
  }
}

class AndroidFolder {
  final String? uri;
  final String? path;

  AndroidFolder({this.uri, this.path});

  static const methodChannel = MethodChannel('com.vicolo.chrono/documents');

  Future<List<AndroidFile>> files() async {
    if (path != null) {
      final directory = Directory(path!);
      return (await directory.list().toList())
          .whereType<File>()
          .map((file) => AndroidFile.fromFile(file))
          .toList();
    } else {
      // Android
      return (await methodChannel.invokeMethod('listFiles', {'uri': uri!}))
          .map((file) => AndroidFile(
              uri: file['uri'],
              name: file['name'],
              size: file['size'],
              modifiedDate:
                  DateTime.fromMillisecondsSinceEpoch(file['modified'])))
          .cast<AndroidFile>()
          .toList();
    }
  }

  Future<List<AndroidFolder>> folders() async {
    if (path != null) {
      final directory = Directory(uri!);
      return (await directory.list().toList())
          .whereType<Directory>()
          .map((directory) => AndroidFolder(uri: directory.path))
          .toList();
    } else {
      // Android
      return (await methodChannel
              .invokeMethod('listDirectories', {'uri': uri!}))
          .map((folder) => AndroidFolder(uri: folder))
          .cast<AndroidFile>()
          .toList();
    }
  }

  String get name {
    if (path != null) return basename(path!);
    return Uri.decodeFull(uri!).split(RegExp(r'[/:]')).last; // Android
  }
}
