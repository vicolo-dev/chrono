
  import 'package:clock_app/common/types/file_item.dart';
import 'package:flutter/material.dart';

IconData getFileItemIcon(FileItem fileItem, bool isPlaying) {
    switch (fileItem.type) {
      case FileItemType.audio:
        return isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded;
      case FileItemType.image:
        return Icons.image;
      case FileItemType.video:
        return Icons.video_label;
      case FileItemType.text:
        return Icons.text_fields;
      case FileItemType.other:
        return Icons.insert_drive_file;
      case FileItemType.directory:
        return Icons.folder;
    }
  }

