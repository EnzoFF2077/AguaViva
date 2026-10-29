import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class PhotoService {
  Future<File> sanitizeAndStore({
    required String sourcePath,
    required String reportId,
  }) async {
    final source = File(sourcePath);
    final decoded = img.decodeImage(await source.readAsBytes());
    if (decoded == null) {
      throw const FormatException('Não foi possível processar a foto.');
    }

    final oriented = img.bakeOrientation(decoded);
    final resized = oriented.width > 1280
        ? img.copyResize(oriented, width: 1280)
        : oriented;
    final bytes = img.encodeJpg(resized, quality: 72);

    final root = await getApplicationDocumentsDirectory();
    final directory = Directory('${root.path}/pending_photos');
    await directory.create(recursive: true);
    final output = File('${directory.path}/$reportId.jpg');
    return output.writeAsBytes(bytes, flush: true);
  }

  Future<File?> pendingPhoto(String reportId) async {
    final root = await getApplicationDocumentsDirectory();
    final file = File('${root.path}/pending_photos/$reportId.jpg');
    return file.existsSync() ? file : null;
  }

  Future<void> removePendingPhoto(String reportId) async {
    final file = await pendingPhoto(reportId);
    if (file != null) await file.delete();
  }
}
