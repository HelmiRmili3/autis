import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;

import '../entities/file.dart';

class FilePicker {
  Future<FileEntity?> pickImage() async {
    final result =
        await fp.FilePicker.platform.pickFiles(type: fp.FileType.image);
    if (result != null && result.files.single.path != null) {
      return FileEntity(
        filepath: result.files.single.path!,
        filename: result.files.single.name,
      );
    }
    return null;
  }

  Future<File?> pickVideo() async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.video,
        allowMultiple: false, // Only allow single file selection
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  Future<FileEntity?> pickAudio() async {
    final result =
        await fp.FilePicker.platform.pickFiles(type: fp.FileType.audio);
    if (result != null && result.files.single.path != null) {
      return FileEntity(
        filepath: result.files.single.path!,
        filename: result.files.single.name,
      );
    }
    return null;
  }

  Future<FileEntity?> pickFiles() async {
    final result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: fp.FileType.custom,
      allowedExtensions: ['json'],
    );
    return FileEntity(
      filepath: result!.files.single.path!,
      filename: result.files.single.name,
    );
  }
}
