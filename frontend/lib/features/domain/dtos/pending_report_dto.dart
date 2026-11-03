import '../enums/report_enums.dart';
import 'report_location_dto.dart';

class PendingReportDto {
  const PendingReportDto({
    required this.id,
    required this.ownerId,
    required this.sourceType,
    required this.sourceName,
    required this.waterColor,
    required this.hasStrongOdor,
    this.description,
    required this.location,
    required this.createdAtClient,
    required this.updatedAtClient,
    required this.photoRelativePath,
    this.syncStage = SyncStage.pendingDocument,
  });

  final String id;
  final String ownerId;
  final WaterSourceType sourceType;
  final String sourceName;
  final WaterColor waterColor;
  final bool hasStrongOdor;
  final String? description;
  final ReportLocationDto location;
  final DateTime createdAtClient;
  final DateTime updatedAtClient;
  final String photoRelativePath;
  final SyncStage syncStage;

  Map<String, Object?> toRow() => {
    'id': id,
    'owner_id': ownerId,
    'source_type': sourceType.code,
    'source_name': sourceName,
    'water_colour': waterColor.code,
    'has_strong_odor': hasStrongOdor ? 1 : 0,
    'description': description,
    'latitude': location.latitude,
    'longitude': location.longitude,
    'accuracy_m': location.accuracy,
    'confirmed': location.confirmed ? 1 : 0,
    'created_at_client': createdAtClient.millisecondsSinceEpoch,
    'updated_at_client': updatedAtClient.millisecondsSinceEpoch,
    'photo_relative_path': photoRelativePath,
    'sync_stage': syncStage.code,
  };

  factory PendingReportDto.fromRow(Map<String, Object?> row) =>
      PendingReportDto(
        id: row['id'] as String,
        ownerId: row['owner_id'] as String,
        sourceType: WaterSourceType.values.byCode(row['source_type']),
        sourceName: row['source_name'] as String,
        waterColor: WaterColor.values.byCode(row['water_colour']),
        hasStrongOdor: row['has_strong_odor'] == 1,
        description: row['description'] as String?,
        location: ReportLocationDto(
          latitude: (row['latitude'] as num).toDouble(),
          longitude: (row['longitude'] as num).toDouble(),
          accuracy: (row['accuracy_m'] as num).toDouble(),
          confirmed: row['confirmed'] == 1,
        ),
        createdAtClient: DateTime.fromMillisecondsSinceEpoch(
          row['created_at_client'] as int,
          isUtc: true,
        ),
        updatedAtClient: DateTime.fromMillisecondsSinceEpoch(
          row['updated_at_client'] as int,
          isUtc: true,
        ),
        photoRelativePath: row['photo_relative_path'] as String,
        syncStage: SyncStage.values.byCode(row['sync_stage']),
      );
}
