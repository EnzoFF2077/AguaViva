import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/reports/domain/entities/report_draft.dart';
import 'package:frontend/features/reports/domain/entities/water_report.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';
import 'package:frontend/features/reports/presentation/controllers/report_controller.dart';

class _SlowRepository implements ReportRepository {
  int watchCalls = 0;

  @override
  Future<void> initialize() => Completer<void>().future;

  @override
  Stream<List<WaterReport>> watchOwnReports() {
    watchCalls++;
    return const Stream<List<WaterReport>>.empty();
  }

  @override
  Future<WaterReport> submit(ReportDraft draft) =>
      throw UnimplementedError('submit não usado neste teste');

  @override
  Future<void> retryPendingUploads() async {}
}

void main() {
  test('a stream de alertas é criada uma única vez', () {
    final repository = _SlowRepository();
    final controller = ReportController(repository);

    final first = controller.reports;
    final second = controller.reports;

    expect(identical(first, second), isTrue);
    expect(repository.watchCalls, 1);
  });

  test('a ativação da sessão termina no limite de tempo', () async {
    final controller = ReportController(
      _SlowRepository(),
      activationTimeout: const Duration(milliseconds: 20),
    );

    await controller.initialize();

    expect(controller.isInitializing, isFalse);
    expect(controller.initializationError, contains('conexão está lenta'));
  });
}
