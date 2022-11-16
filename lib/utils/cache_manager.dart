// Dart imports:
import 'dart:io';

// Package imports:
import 'package:path_provider/path_provider.dart';

class CacheManager {
  static Future<void> emptyCache() async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    dir.create();
  }
}
