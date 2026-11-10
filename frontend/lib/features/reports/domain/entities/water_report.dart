import '../../../domain/dtos/report_location_dto.dart';
import '../../../domain/enums/report_enums.dart';

export '../../../domain/enums/report_enums.dart';

typedef ReportLocation = ReportLocationDto;

class WaterReport {
  const WaterReport({
    required this.id,
    required this.ownerId,
    required this.sourceType,
    required this.sourceName,
    required this.waterColor,
    required this.hasStrongOdor,
    required this.description,
    required this.location,
    required this.photoStoragePath,
    required this.photoStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.responseMessage,
    this.hasPendingWrites = false,
  });

  final String id;
  final String ownerId;
  final WaterSourceType sourceType;
  final String sourceName;
  final WaterColor waterColor;
  final bool hasStrongOdor;
  final String? description;
  final ReportLocation location;
  final String? photoStoragePath;
  final PhotoUploadStatus photoStatus;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? responseMessage;
  final bool hasPendingWrites;
}
