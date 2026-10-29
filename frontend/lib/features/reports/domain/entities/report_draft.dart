import 'water_report.dart';

class ReportDraft {
  const ReportDraft({
    required this.sourceType,
    required this.sourceName,
    required this.waterColor,
    required this.hasStrongOdor,
    required this.description,
    required this.location,
    required this.originalPhotoPath,
  });

  final WaterSourceType sourceType;
  final String sourceName;
  final WaterColor waterColor;
  final bool hasStrongOdor;
  final String? description;
  final ReportLocation location;
  final String originalPhotoPath;
}
