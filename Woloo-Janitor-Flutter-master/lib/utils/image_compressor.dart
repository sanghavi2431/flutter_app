import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woloo_smart_hygiene/utils/local_image_cleanup.dart';

/// Compresses janitor capture/upload photos (same settings as selfie camera).
class ImageCompressor {
  ImageCompressor._();

  static const int quality = 50;
  static const int maxWidth = 1280;
  static const int maxHeight = 1280;

  /// Writes a compressed JPEG under `{temp}/woloo/` and optionally deletes [file]
  /// when it is a different path than the result.
  static Future<File> compressFile(
    File file, {
    bool deleteOriginal = false,
  }) async {
    try {
      final Directory extDir = await getTemporaryDirectory();
      final testDir = await Directory(
        '${extDir.path}/${LocalImageCleanup.wolooTempFolder}',
      ).create(recursive: true);
      final String targetPath =
          '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: maxWidth,
        minHeight: maxHeight,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        debugPrint('ImageCompressor: compress returned null, using original');
        return file;
      }

      final compressed = File(result.path);
      if (deleteOriginal && file.path != compressed.path) {
        await LocalImageCleanup.deleteFile(file);
      }
      return compressed;
    } catch (e) {
      debugPrint('ImageCompressor failed: $e');
      return file;
    }
  }

  static Future<List<File>> compressFiles(
    List<File> files, {
    bool deleteOriginal = false,
  }) async {
    final out = <File>[];
    for (final file in files) {
      out.add(await compressFile(file, deleteOriginal: deleteOriginal));
    }
    return out;
  }
}
