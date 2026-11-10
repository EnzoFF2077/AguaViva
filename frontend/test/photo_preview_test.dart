import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/reports/data/services/photo_service.dart';
import 'package:image/image.dart' as img;

void main() {
  test('prévia de uma foto detalhada cabe no documento e remove EXIF', () {
    final photo = img.Image(width: 1060, height: 1024);
    final random = Random(43);
    for (final pixel in photo) {
      pixel.setRgb(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }
    photo.exif.imageIfd['Make'] = 'Aparelho de teste';
    final original = img.encodeJpg(photo, quality: 95);
    expect(original.length, greaterThan(PhotoService.maxPreviewBytes));
    expect(img.decodeJpg(original)!.exif.imageIfd['Make'], isNotNull);
    final preview = PhotoService().createPreview(original);
    expect(preview.length, lessThanOrEqualTo(PhotoService.maxPreviewBytes));
    expect(img.decodeJpg(preview)!.exif.imageIfd['Make'], isNull);
  });

  test('rejeita conteúdo inválido antes de gravar o relato', () {
    expect(
      () => PhotoService().createPreview(Uint8List(64)),
      throwsFormatException,
    );
  });
}
