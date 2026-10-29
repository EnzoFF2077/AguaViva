enum WaterSourceType { well, spring, tap, river, other }

enum WaterColor { normal, milky, darkOrMuddy }

enum ReportStatus {
  pendingPhoto,
  waitingInternet,
  submitted,
  underReview,
  resolved,
}

enum PhotoUploadStatus { pending, uploading, uploaded, failed }

class ReportLocation {
  const ReportLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.confirmed,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final bool confirmed;
}

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

extension WaterSourceTypeLabel on WaterSourceType {
  String get label => switch (this) {
    WaterSourceType.well => 'Poço',
    WaterSourceType.spring => 'Nascente',
    WaterSourceType.tap => 'Torneira',
    WaterSourceType.river => 'Rio ou riacho',
    WaterSourceType.other => 'Outro',
  };
}

extension WaterColorLabel on WaterColor {
  String get label => switch (this) {
    WaterColor.normal => 'Normal',
    WaterColor.milky => 'Leitosa',
    WaterColor.darkOrMuddy => 'Escura ou com barro',
  };
}

extension ReportStatusLabel on ReportStatus {
  String get label => switch (this) {
    ReportStatus.pendingPhoto => 'Preparando foto',
    ReportStatus.waitingInternet => 'Aguardando internet',
    ReportStatus.submitted => 'Enviada',
    ReportStatus.underReview => 'Em análise',
    ReportStatus.resolved => 'Resolvida',
  };
}
