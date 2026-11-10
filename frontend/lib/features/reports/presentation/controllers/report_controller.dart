import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/report_draft.dart';
import '../../domain/entities/water_report.dart';
import '../../domain/repositories/report_repository.dart';

class ReportController extends ChangeNotifier {
  ReportController(this._repository);

  final ReportRepository _repository;

  bool _isInitializing = true;
  bool _isSubmitting = false;
  String? _initializationError;

  bool get isInitializing => _isInitializing;
  bool get isSubmitting => _isSubmitting;
  String? get initializationError => _initializationError;
  Stream<List<WaterReport>> get reports => _repository.watchOwnReports();

  Future<void> initialize() async {
    _isInitializing = true;
    _initializationError = null;
    notifyListeners();
    try {
      await _repository.initialize();
    } on FirebaseException catch (error) {
      debugPrint(
        'Ativação do ÁguaViva: ${error.plugin}/${error.code}: ${error.message}',
      );
      _initializationError = switch (error.code) {
        'network-request-failed' => 'Confira a conexão e tente novamente.',
        'keychain-error' =>
          'O macOS não conseguiu salvar o acesso anônimo no Chaves (Keychain).',
        'operation-not-allowed' || 'admin-restricted-operation' =>
          'O projeto Firebase não permitiu o acesso anônimo.',
        _ => 'Falha ao ativar o acesso (${error.plugin}/${error.code}).',
      };
    } catch (error, stack) {
      debugPrint('Ativação do ÁguaViva: $error\n$stack');
      _initializationError =
          'Não foi possível iniciar o acesso. Tente novamente.';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<WaterReport> submit(ReportDraft draft) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      return await _repository.submit(draft);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> retryPendingUploads() => _repository.retryPendingUploads();
}
