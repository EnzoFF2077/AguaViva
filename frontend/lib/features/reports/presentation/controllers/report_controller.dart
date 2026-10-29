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
    } catch (_) {
      _initializationError =
          'Conecte-se à internet uma vez para ativar o acesso anônimo.';
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
