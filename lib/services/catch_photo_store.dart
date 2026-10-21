import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Copies a picked photo into app documents. Returns null when the copy fails.
Future<String?> persistCatchPhoto({
  required String sourcePath,
  required String catchId,
}) async {
  try {
    final source = File(sourcePath);
    if (!await source.exists()) {
      return null;
    }
    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory('${documents.path}/catches');
    await folder.create(recursive: true);
    final dot = sourcePath.lastIndexOf('.');
    final extension = dot >= 0 && dot > sourcePath.lastIndexOf('/')
        ? sourcePath.substring(dot)
        : '.jpg';
    final destination = File('${folder.path}/$catchId$extension');
    final copied = await source.copy(destination.path);
    return copied.path;
  } catch (_) {
    return null;
  }
}
