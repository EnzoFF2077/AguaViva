import '../entities/report_draft.dart';
import '../entities/water_report.dart';

abstract interface class ReportRepository {
  Future<void> initialize();
  Stream<List<WaterReport>> watchOwnReports();
  Future<WaterReport> submit(ReportDraft draft);
  Future<void> retryPendingUploads();
}
