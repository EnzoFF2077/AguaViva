import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../widgets/region_map.dart';

/// Tela inicial do protótipo: mapa da região, legenda de qualidade da água,
/// alertas próximos e o chamado para registrar um novo alerta.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onCreateReport,
    this.onSignOut,
    this.showMapTiles = true,
  });

  final VoidCallback onCreateReport;

  /// Quando presente (conta com e-mail), mostra o botao de sair da conta.
  final VoidCallback? onSignOut;

  /// Desliga o download de tiles do OpenStreetMap (usado em testes sem rede).
  final bool showMapTiles;

  @override
  Widget build(BuildContext context) {
    final spots = AlertSpot.monitoredSpots;

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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            RegionMap(
              spots: spots,
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
            for (final spot in spots.take(2)) ...[
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
                Icon(Icons.water_drop, color: color, size: 22),
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
