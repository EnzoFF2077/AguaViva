import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/water_report.dart';

abstract final class WaterReportModel {
  static WaterReport fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    final location = data['location'] as Map<String, dynamic>? ?? const {};
    final point = location['point'] as GeoPoint?;
    final photo = data['photo'] as Map<String, dynamic>? ?? const {};
    final response = data['response'] as Map<String, dynamic>? ?? const {};
    final createdAt = _date(data['createdAtClient']) ?? DateTime.now();

    return WaterReport(
      id: document.id,
      ownerId: data['ownerId'] as String? ?? '',
      sourceType: _sourceType(data['sourceType'] as String?),
      sourceName: data['sourceName'] as String? ?? '',
      waterColor: _waterColor(data['waterColor'] as String?),
      hasStrongOdor: data['hasStrongOdor'] as bool? ?? false,
      description: data['description'] as String?,
      location: ReportLocation(
        latitude: point?.latitude ?? 0,
        longitude: point?.longitude ?? 0,
        accuracy: (location['accuracy'] as num?)?.toDouble() ?? 0,
        confirmed: location['confirmed'] as bool? ?? false,
      ),
      photoStoragePath: photo['storagePath'] as String?,
      photoStatus: _photoStatus(photo['status'] as String?),
      status: _status(data['caseStatus'] as String?),
      createdAt: createdAt,
      updatedAt: _date(data['updatedAtClient']) ?? createdAt,
      responseMessage: response['message'] as String?,
      hasPendingWrites: document.metadata.hasPendingWrites,
    );
  }

  static Map<String, dynamic> createData({
    required String ownerId,
    required WaterSourceType sourceType,
    required String sourceName,
    required WaterColor waterColor,
    required bool hasStrongOdor,
    required String? description,
    required ReportLocation location,
    required DateTime now,
  }) {
    return {
      'ownerId': ownerId,
      'sourceType': sourceType.name,
      'sourceName': sourceName,
      'waterColor': waterColor.name,
      'hasStrongOdor': hasStrongOdor,
      'description': description,
      'location': {
        'point': GeoPoint(location.latitude, location.longitude),
        'accuracy': location.accuracy,
        'confirmed': location.confirmed,
      },
      'photo': {'storagePath': null, 'status': PhotoUploadStatus.pending.name},
      'caseStatus': ReportStatus.waitingInternet.name,
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtClient': Timestamp.fromDate(now),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedAtClient': Timestamp.fromDate(now),
      'submittedAt': null,
      'response': null,
    };
  }

  static DateTime? _date(Object? value) => switch (value) {
    Timestamp timestamp => timestamp.toDate(),
    DateTime date => date,
    _ => null,
  };

  static WaterSourceType _sourceType(String? value) =>
      WaterSourceType.values.firstWhere(
        (item) => item.name == value,
        orElse: () => WaterSourceType.other,
      );

  static WaterColor _waterColor(String? value) => WaterColor.values.firstWhere(
    (item) => item.name == value,
    orElse: () => WaterColor.normal,
  );

  static ReportStatus _status(String? value) => ReportStatus.values.firstWhere(
    (item) => item.name == value,
    orElse: () => ReportStatus.waitingInternet,
  );

  static PhotoUploadStatus _photoStatus(String? value) =>
      PhotoUploadStatus.values.firstWhere(
        (item) => item.name == value,
        orElse: () => PhotoUploadStatus.pending,
      );
}
