import 'dart:typed_data';

import '../enums/report_enums.dart';
import 'report_location_dto.dart';

class AuthIdentityDto {
  const AuthIdentityDto(this.uid);
  final String uid;
}

class ReportPhotoDto {
  const ReportPhotoDto({
    required this.status,
    this.storagePath,
    this.previewBytes,
  });
  final PhotoUploadStatus status;
  final String? storagePath;
  final Uint8List? previewBytes;
}

class ReportPreviewDto {
  const ReportPreviewDto({required this.reportId, required this.previewBytes});
  final String reportId;
  final Uint8List previewBytes;
}

class ReportResponseDto {
  const ReportResponseDto(this.message);
  final String? message;
}

class ReportDto {
  const ReportDto({
    required this.id,
    required this.ownerId,
    required this.sourceType,
    required this.sourceName,
    required this.waterColor,
    required this.hasStrongOdor,
    this.description,
    required this.location,
    required this.photo,
    required this.caseStatus,
    this.createdAt,
    this.updatedAt,
    required this.createdAtClient,
    required this.updatedAtClient,
    this.submittedAt,
    this.response,
  });

  final String id;
  final String ownerId;
  final WaterSourceType sourceType;
  final String sourceName;
  final WaterColor waterColor;
  final bool hasStrongOdor;
  final String? description;
  final ReportLocationDto location;
  final ReportPhotoDto photo;
  final ReportStatus caseStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime createdAtClient;
  final DateTime updatedAtClient;
  final DateTime? submittedAt;
  final ReportResponseDto? response;
}
