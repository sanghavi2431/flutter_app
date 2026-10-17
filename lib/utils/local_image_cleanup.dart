import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Best-effort deletion of local capture/upload files so Janitor storage
/// does not grow after each task submit.
class LocalImageCleanup {
  LocalImageCleanup._();

  static const wolooTempFolder = 'woloo';

  static Future<void> deleteFile(File? file) async {
    if (file == null) return;
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint('LocalImageCleanup deleted: ${file.path}');
      }
    } catch (e) {
      debugPrint('LocalImageCleanup delete failed: $e');
    }
  }

  static Future<void> deleteFiles(Iterable<File>? files) async {
    if (files == null) return;
    for (final file in files) {
      await deleteFile(file);
    }
  }

  /// Deletes leftover camera captures under `{temp}/woloo/`.
  static Future<void> clearWolooTemp() async {
    try {
      final temp = await getTemporaryDirectory();
      final dir = Directory('${temp.path}/$wolooTempFolder');
      if (!await dir.exists()) return;

      await for (final entity in dir.list(followLinks: false)) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (_) {
          // Best-effort per file.
        }
      }
      debugPrint('LocalImageCleanup cleared ${dir.path}');
    } catch (e) {
      debugPrint('LocalImageCleanup clearWolooTemp failed: $e');
    }
  }
}
