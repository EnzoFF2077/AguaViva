import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/water_report.dart';
import '../controllers/report_controller.dart';
import '../widgets/region_map.dart';

/// Tela inicial do protótipo: mapa da região, legenda de qualidade da água,
/// alertas reais próximos e o chamado para registrar um novo alerta.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.onCreateReport,
    this.onSignOut,
    this.showMapTiles = true,
  });

  final ReportController controller;
  final VoidCallback onCreateReport;

  /// Quando presente (conta com e-mail), mostra o botao de sair da conta.
  final VoidCallback? onSignOut;

  /// Desliga o download de tiles do OpenStreetMap (usado em testes sem rede).
  final bool showMapTiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ÁguaViva'),
            Text(
              'Sua região · 12 pontos monitorados',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          if (onSignOut != null)
            IconButton(
              tooltip: 'Sair da conta',
              onPressed: () => _confirmSignOut(context),
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<WaterReport>>(
          stream: controller.reports,
          builder: (context, snapshot) {
            final alertSpots = (snapshot.data ?? const <WaterReport>[])
                .map(AlertSpot.fromReport)
                .toList(growable: false);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                RegionMap(
                  spots: AlertSpot.monitoredSpots,
                  alertSpots: alertSpots,
                  onCreateReport: onCreateReport,
                  showTiles: showMapTiles,
                ),
                const SizedBox(height: 10),
                const _Legend(),
                const SizedBox(height: 24),
                Text(
                  'Alertas perto de você',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (snapshot.hasError)
                  const _MessageState(
                    icon: Icons.cloud_off,
                    title: 'Não foi possível carregar os alertas',
                    message: 'Confira sua conexão e tente novamente.',
                  )
                else if (!snapshot.hasData)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (alertSpots.isEmpty)
                  const _EmptyAlerts()
                else
                  for (final spot in alertSpots) ...[
                    _AlertCard(
                      title: spot.title,
                      description: spot.description,
                      status: spot.status,
                      color: spot.color,
                      time: spot.time,
                    ),
                    const SizedBox(height: 12),
                  ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onCreateReport,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('A água está estranha'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Você precisará entrar novamente para ver seus alertas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed == true) onSignOut?.call();
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LegendItem(color: AppColors.success, label: 'Limpa'),
        _LegendItem(color: AppColors.warning, label: 'Suspeita'),
        _LegendItem(color: AppColors.danger, label: 'Contaminada'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DEE9)),
      ),
      child: const Column(
        children: [
          Icon(Icons.water_drop_outlined, color: AppColors.muted, size: 34),
          SizedBox(height: 10),
          Text(
            'Nenhum alerta perto de você',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            'Quando houver alertas registrados nesta região, eles aparecerão aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DEE9)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.muted, size: 34),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.description,
    required this.status,
    required this.color,
    required this.time,
  });

  final String title;
  final String description;
  final String status;
  final Color color;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceSoft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(time, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
