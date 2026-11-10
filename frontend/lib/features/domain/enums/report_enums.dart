abstract interface class ReportCode {
  String get code;
}

extension ReportCodes<E extends ReportCode> on Iterable<E> {
  E byCode(Object? value) => firstWhere((entry) => entry.code == value);
}

enum WaterSourceType implements ReportCode {
  well('poço'),
  spring('nascente'),
  tap('torneira'),
  river('rio'),
  other('outro');

  const WaterSourceType(this.code);
  @override
  final String code;
}

enum WaterColor implements ReportCode {
  normal('normal'),
  milky('leitosa'),
  darkOrMuddy('escuraOuSuja');

  const WaterColor(this.code);
  @override
  final String code;
}

enum ReportStatus implements ReportCode {
  pendingPhoto('pendenteFoto'),
  waitingInternet('esperaInternet'),
  submitted('enviado'),
  underReview('sobRevisao'),
  resolved('resolvido');

  const ReportStatus(this.code);
  @override
  final String code;
}

enum PhotoUploadStatus implements ReportCode {
  pending('Pendente'),
  uploading('Uploading'),
  uploaded('Uploaded'),
  failed('Falho');

  const PhotoUploadStatus(this.code);
  @override
  final String code;
}

enum SyncStage implements ReportCode {
  pendingDocument('documento_pendente'),
  pendingPhoto('pendente_foto');

  const SyncStage(this.code);
  @override
  final String code;
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
