class ReportLocationDto {
  const ReportLocationDto({
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
