import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/report_draft.dart';
import '../../domain/entities/water_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/water_report_model.dart';
import '../services/photo_service.dart';

class FirebaseReportRepository implements ReportRepository {
  FirebaseReportRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Connectivity? connectivity,
    PhotoService? photoService,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage,
       _connectivity = connectivity ?? Connectivity(),
       _photoService = photoService ?? PhotoService();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage? _storage;
  final Connectivity _connectivity;
  final PhotoService _photoService;
  final _uuid = const Uuid();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  CollectionReference<Map<String, dynamic>> get _reports =>
      _firestore.collection('reports');

  @override
  Future<void> initialize() async {
    await _ensureAnonymousUser();
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      if (!results.contains(ConnectivityResult.none)) {
        unawaited(retryPendingUploads());
      }
    });
    unawaited(retryPendingUploads());
  }

  @override
  Stream<List<WaterReport>> watchOwnReports() async* {
    final user = await _ensureAnonymousUser();
    yield* _reports
        .where('ownerId', isEqualTo: user.uid)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
          final reports = snapshot.docs
              .map(WaterReportModel.fromDocument)
              .toList(growable: false);
          return reports..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        });
  }

  @override
  Future<WaterReport> submit(ReportDraft draft) async {
    final user = await _ensureAnonymousUser();
    final reportId = _uuid.v4();
    final now = DateTime.now();
    final document = _reports.doc(reportId);

    final bytes = draft.photoBytes;
    if (kIsWeb && (bytes == null || bytes.isEmpty)) {
      throw const FormatException('Selecione uma foto para enviar.');
    }
    final data = WaterReportModel.createData(
      ownerId: user.uid,
      sourceType: draft.sourceType,
      sourceName: draft.sourceName,
      waterColor: draft.waterColor,
      hasStrongOdor: draft.hasStrongOdor,
      description: draft.description,
      location: draft.location,
      now: now,
      previewBytes: kIsWeb ? _photoService.createPreview(bytes!) : null,
    );
    if (kIsWeb) {
      final upload = document.set(data).then((_) => _finishWebReport(document));
      await upload.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // O SDK continua sincronizando a escrita persistida no navegador.
          unawaited(
            upload.catchError((Object error) {
              debugPrint('Falha ao sincronizar o relato: $error');
            }),
          );
        },
      );
      return WaterReportModel.fromDocument(
        await document.get(const GetOptions(source: Source.cache)),
      );
    }

    await _photoService.sanitizeAndStore(
      sourcePath: draft.originalPhotoPath,
      reportId: reportId,
    );
    await document.set(data);

    // O alerta já está seguro no cache persistente do Firestore. O upload não
    // bloqueia a confirmação para o usuário em redes rurais lentas.
    unawaited(_tryUpload(document, user.uid));
    final snapshot = await document.get(const GetOptions(source: Source.cache));
    return WaterReportModel.fromDocument(snapshot);
  }

  @override
  Future<void> retryPendingUploads() async {
    final user = _auth.currentUser;
    if (user == null || !(await _hasConnection())) return;

    final snapshot = await _reports
        .where('ownerId', isEqualTo: user.uid)
        .get(const GetOptions(source: Source.cache));
    for (final document in snapshot.docs) {
      final report = WaterReportModel.fromDocument(document);
      if (report.photoStatus != PhotoUploadStatus.uploaded) {
        if (kIsWeb) {
          if (document.data()['photo']?['previewBytes'] is Blob) {
            await _finishWebReport(document.reference);
          }
        } else {
          await _tryUpload(document.reference, user.uid);
        }
      }
    }
  }

  Future<void> _finishWebReport(
    DocumentReference<Map<String, dynamic>> document,
  ) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(document);
        final data = snapshot.data();
        if (data == null ||
            !(data['caseStatus'] == ReportStatus.waitingInternet.name ||
                data['caseStatus'] == ReportStatus.pendingPhoto.name) ||
            data['photo']?['previewBytes'] is! Blob)
          return;
        transaction.update(document, {
          'photo.status': PhotoUploadStatus.uploaded.name,
          'caseStatus': ReportStatus.submitted.name,
          'submittedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedAtClient': Timestamp.now(),
        });
      });
    } on FirebaseException catch (error) {
      // O documento com a foto já existe. A próxima sincronização retoma o status.
      debugPrint('Atualização do status do relato: ${error.code}');
    }
  }

  Future<User> _ensureAnonymousUser() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final credential = await _auth.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw StateError('Não foi possível iniciar o acesso anônimo.');
    }
    return user;
  }

  Future<void> _tryUpload(
    DocumentReference<Map<String, dynamic>> document,
    String ownerId,
  ) async {
    if (!(await _hasConnection())) return;
    final file = await _photoService.pendingPhoto(document.id);
    if (file == null) return;

    final path = 'reports/$ownerId/${document.id}/water.jpg';
    final reference = (_storage ?? FirebaseStorage.instance).ref(path);
    UploadTask? task;
    try {
      await document.update({
        'photo.status': PhotoUploadStatus.uploading.name,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedAtClient': Timestamp.now(),
      });
      task = reference.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'reportId': document.id},
        ),
      );
      await task.timeout(const Duration(seconds: 45));
      await document.update({
        'photo.storagePath': path,
        'photo.status': PhotoUploadStatus.uploaded.name,
        'caseStatus': ReportStatus.submitted.name,
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedAtClient': Timestamp.now(),
      });
      await _photoService.removePendingPhoto(document.id);
    } on TimeoutException {
      await task?.cancel();
      await _markUploadPending(document);
    } on FirebaseException {
      await _markUploadPending(document);
    } on SocketException {
      await _markUploadPending(document);
    } catch (_) {
      try {
        await _markUploadPending(document);
      } catch (_) {
        // O Firestore tentará novamente as escritas já aceitas no cache.
      }
    }
  }

  Future<void> _markUploadPending(
    DocumentReference<Map<String, dynamic>> document,
  ) {
    return document.update({
      'photo.status': PhotoUploadStatus.pending.name,
      'caseStatus': ReportStatus.waitingInternet.name,
      'updatedAtClient': Timestamp.now(),
    });
  }

  Future<bool> _hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void dispose() => _connectivitySubscription?.cancel();
}
