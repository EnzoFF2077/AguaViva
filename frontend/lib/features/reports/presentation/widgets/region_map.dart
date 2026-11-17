import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_theme.dart';

/// Um ponto monitorado exibido no mapa da página inicial.
@immutable
class AlertSpot {
  const AlertSpot({
    required this.point,
    required this.title,
    required this.description,
    required this.status,
    required this.time,
    required this.color,
  });

  final LatLng point;
  final String title;
  final String description;
  final String status;
  final String time;
  final Color color;

  /// Pontos da região de demonstração (Recife/PE).
  ///
  /// Os dois primeiros também aparecem como cartões na home, mantendo uma
  /// única fonte de verdade entre o mapa e a lista de alertas.
  static const List<AlertSpot> monitoredSpots = [
    AlertSpot(
      point: LatLng(-8.06300, -34.89500),
      title: 'Poço do Sítio Boa Vista',
      description: 'Água esbranquiçada e com cheiro forte',
      status: 'Contaminada',
      time: 'há 2 h',
      color: AppColors.danger,
    ),
    AlertSpot(
      point: LatLng(-8.03600, -34.86100),
      title: 'Torneira comunitária — Rua 7',
      description: 'Água com cor de barro depois da chuva',
      status: 'Em análise',
      time: 'há 5 h',
      color: AppColors.warning,
    ),
    AlertSpot(
      point: LatLng(-8.05100, -34.88400),
      title: 'Poço da Vila Esperança',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 1 dia',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.04200, -34.90200),
      title: 'Nascente do Alto do Céu',
      description: 'Água clara e sem odor',
      status: 'Limpa',
      time: 'há 2 dias',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.05700, -34.87000),
      title: 'Cisterna da Escola Municipal',
      description: 'Cor leitosa, aguardando análise',
      status: 'Suspeita',
      time: 'há 6 h',
      color: AppColors.warning,
    ),
    AlertSpot(
      point: LatLng(-8.04700, -34.87800),
      title: 'Torneira do Mercado',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 3 dias',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.06600, -34.91300),
      title: 'Poço do Bairro Novo',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 4 dias',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.03100, -34.89000),
      title: 'Riozinho da Várzea',
      description: 'Água escura após as chuvas',
      status: 'Contaminada',
      time: 'há 8 h',
      color: AppColors.danger,
    ),
    AlertSpot(
      point: LatLng(-8.05900, -34.90600),
      title: 'Poço do Sítio São João',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 5 dias',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.04000, -34.86800),
      title: 'Fonte Dona Maria',
      description: 'Cheiro de cloro acima do normal',
      status: 'Suspeita',
      time: 'há 1 dia',
      color: AppColors.warning,
    ),
    AlertSpot(
      point: LatLng(-8.06900, -34.88100),
      title: 'Poço da Rua das Palmeiras',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 6 dias',
      color: AppColors.success,
    ),
    AlertSpot(
      point: LatLng(-8.04900, -34.87200),
      title: 'Torneira da UBS Alyrio Freitas',
      description: 'Sem alterações na última visita',
      status: 'Limpa',
      time: 'há 7 dias',
      color: AppColors.success,
    ),
  ];
}

/// Mapa interativo com OpenStreetMap, marcadores dos pontos monitorados e
/// botão para centralizar na localização atual do usuário.
class RegionMap extends StatefulWidget {
  const RegionMap({
    super.key,
    required this.spots,
    required this.onCreateReport,
    this.showTiles = true,
  });

  final List<AlertSpot> spots;
  final VoidCallback onCreateReport;

  /// Permite desligar o download de tiles em testes sem rede.
  final bool showTiles;

  @override
  State<RegionMap> createState() => _RegionMapState();
}

class _RegionMapState extends State<RegionMap> {
  static const _initialCenter = LatLng(-8.04800, -34.88400);

  final MapController _controller = MapController();
  LatLng _center = _initialCenter;
  bool _locating = false;

  Future<void> _centerOnUser() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _message('Ative a localização do aparelho para usar este recurso.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _message('Permita o acesso à localização para centralizar o mapa.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      setState(() => _center = LatLng(position.latitude, position.longitude));
      _controller.move(_center, 15);
      _message('Mapa centralizado na sua localização.');
    } catch (_) {
      _message('Não encontramos sua localização. Tente novamente.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _showSpot(AlertSpot spot) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.place, color: spot.color, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      spot.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(spot.description),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: spot.color.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      spot.status,
                      style: TextStyle(
                        color: spot.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(spot.time, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Coordenadas: ${spot.point.latitude.toStringAsFixed(5)}, '
                '${spot.point.longitude.toStringAsFixed(5)}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  widget.onCreateReport();
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Registrar novo alerta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 12.5,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                if (widget.showTiles)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'br.com.aguaviva.app/1.0',
                    maxNativeZoom: 19,
                  )
                else
                  const ColoredBox(color: Color(0xFFE4EFF7)),
                MarkerLayer(
                  markers: [
                    for (final spot in widget.spots)
                      Marker(
                        point: spot.point,
                        width: 48,
                        height: 60,
                        alignment: Alignment.bottomCenter,
                        child: Semantics(
                          button: true,
                          label: 'Marcador: ${spot.title}, ${spot.status}',
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _showSpot(spot),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x33000000),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: spot.color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.water_drop,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: spot.color,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
            Positioned(
              right: 12,
              bottom: 38,
              child: FloatingActionButton.small(
                heroTag: 'region-map-my-location',
                tooltip: 'Minha localização',
                onPressed: _locating ? null : _centerOnUser,
                child: _locating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
