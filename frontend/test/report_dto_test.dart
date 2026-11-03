import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/domain/dtos/pending_report_dto.dart';
import 'package:frontend/features/domain/dtos/report_location_dto.dart';
import 'package:frontend/features/domain/enums/report_enums.dart';
import 'package:frontend/features/reports/data/models/water_report_model.dart';

void main() {
  test('preserva a linha SQLite ao retomar uma foto pendente', () {
    final row = <String, Object?>{
      'id': 'r1',
      'owner_id': 'u1',
      'source_type': 'poço',
      'source_name': 'Poço Azul',
      'water_colour': 'escuraOuSuja',
      'has_strong_odor': 1,
      'description': null,
      'latitude': -9,
      'longitude': -35,
      'accuracy_m': 2,
      'confirmed': 1,
      'created_at_client': 1000,
      'updated_at_client': 2000,
      'photo_relative_path': 'pending_photos/r1.jpg',
      'sync_stage': 'pendente_foto',
    };
    final dto = PendingReportDto.fromRow(row);
    expect(dto.syncStage, SyncStage.pendingPhoto);
    expect(dto.sourceType, WaterSourceType.well);
    expect(dto.toRow(), row);
  });

  test('lê o formato do piloto e separa os horários do cliente e servidor', () {
    final clientTime = DateTime.utc(2026, 11, 3);
    final serverTime = clientTime.add(const Duration(hours: 2));
    final data = WaterReportModel.createData(
      ownerId: 'u1',
      sourceType: WaterSourceType.well,
      sourceName: 'Poço Azul',
      waterColor: WaterColor.milky,
      hasStrongOdor: false,
      description: null,
      location: const ReportLocationDto(
        latitude: -9,
        longitude: -35,
        accuracy: 2,
        confirmed: true,
      ),
      now: clientTime,
    );
    expect(data['caseStatus'], 'waitingInternet');
    expect(data['sourceType'], 'well');
    data['createdAt'] = Timestamp.fromDate(serverTime);
    data['response'] = {'message': 'Recebido'};
    final dto = WaterReportModel.fromMap('r1', data);
    expect(dto.createdAt!.isAtSameMomentAs(serverTime), isTrue);
    expect(dto.createdAtClient.isAtSameMomentAs(clientTime), isTrue);
    expect(dto.photo.status, PhotoUploadStatus.pending);
    expect(dto.location.confirmed, isTrue);
    expect(dto.response?.message, 'Recebido');
  });
}
