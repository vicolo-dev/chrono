// import 'dart:async';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// /// Android-specific. uses a platform channel which calls Scoped Storage APIs
// /// so that we can list directory contents and read files from a selected folder
// class AndroidPlatformFile {
//   final File file;
//
//   AndroidPlatformFile(this.file);
//
//   static const methodChannel = MethodChannel('com.vicolo.chrono/documents');
//   
//   Stream<List<int>> openRead() async* {
//     const int chunkSize = 1024 * 1024; // 1MB
//     int offset = 0;
//     bool moreData = true;
//
//     while (moreData) {
//       try {
//         final Map<String, dynamic> arguments = {
//           'uri': file.uri,
//           'offset': offset,
//           'chunkSize': chunkSize,
//         };
//         final List<int>? chunk = await methodChannel.invokeMethod('getFileChunk', arguments);
//         if (chunk == null || chunk.isEmpty) {
//           moreData = false;
//         } else {
//           yield Uint8List.fromList(chunk);
//           offset += chunk.length;
//         }
//       } on PlatformException catch (e) {
//         if (kDebugMode) print("Failed to get file chunk: ${e.message}");
//         moreData = false;
//       }
//     }
//   }
// }
//
//
// class AndroidPlatformFolder {
//   final String? path;
//
//   AndroidPlatformFolder({this.path});
//
//
//
//   static const methodChannel = MethodChannel('com.yourCompany.app/documents');
//
//   dispose() {
//     if (Platform.isIOS) {
//       methodChannel.invokeMethod('stopAccessingSecurityScopedResource');
//     }
//   }
//
//   Future<List<AndroidPlatformFile>> files() async {
//     if (path != null) {
//       final directory = Directory(path!);
//       return (await directory.list().toList())
//         .whereType<File>()
//         .map((file) => AndroidPlatformFile(file))
//         .toList();
//     } else {
//       // Android
//       return (await methodChannel.invokeMethod('listFiles', { 'uri': uri! }))
//         .map((file) => AndroidPlatformFile(uri: file['uri'], name: file['name'], size: file['size'], modifiedDate: DateTime.fromMillisecondsSinceEpoch(file['modified'])))
//         .cast<AndroidPlatformFile>()
//         .toList();
//     }
//   }
//
//   
//   Future<List<AndroidPlatformFolder>> folders() async {
//     if (path != null) {
//       final directory = Directory(path!);
//       return (await directory.list().toList())
//         .whereType<Directory>()
//         .map((directory) => PlatformFile(path: directory.path))
//         .toList();
//     } else {
//       // Android
//       return (await methodChannel.invokeMethod('listDirectories', { 'uri': uri! }))
//         .map((folder) => AndroidPlatformFolder(uri: folder))
//         .cast<AndroidPlatformFile>()
//         .toList();
//     }
//   }
//
//   String get name {
//     if (path != null) return p.basename(path!);
//     return Uri.decodeFull(uri!).split(RegExp(r'[/:]')).last;  // Android
//   }
// }
