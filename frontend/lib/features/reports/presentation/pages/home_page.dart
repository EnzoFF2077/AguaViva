import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Tela inicial do protótipo: mapa da região, legenda de qualidade da água,
/// alertas próximos e o chamado para registrar um novo alerta.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onCreateReport, this.onSignOut});

  final VoidCallback onCreateReport;

  /// Quando presente (conta com e-mail), mostra o botao de sair da conta.
  final VoidCallback? onSignOut;

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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const _RegionMap(),
            const SizedBox(height: 10),
            const _Legend(),
            const SizedBox(height: 24),
            Text(
              'Alertas perto de você',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const _AlertCard(
              title: 'Poço do Sítio Boa Vista',
              description: 'Água esbranquiçada e com cheiro forte',
              status: 'Contaminada',
              color: AppColors.danger,
              time: 'há 2 h',
            ),
            const SizedBox(height: 12),
            const _AlertCard(
              title: 'Torneira comunitária — Rua 7',
              description: 'Água com cor de barro depois da chuva',
              status: 'Em análise',
              color: AppColors.warning,
              time: 'há 5 h',
            ),
            const SizedBox(height: 28),
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

/// Mapa ilustrativo da região com os pontos monitorados.
class _RegionMap extends StatelessWidget {
  const _RegionMap();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 170,
        child: CustomPaint(
          painter: _MapPainter(),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE4EFF7),
    );

    final street = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawLine(
        Offset(0, size.height * 0.38),
        Offset(size.width, size.height * 0.30),
        street,
      )
      ..drawLine(
        Offset(size.width * 0.30, 0),
        Offset(size.width * 0.42, size.height),
        street,
      )
      ..drawLine(
        Offset(size.width * 0.72, 0),
        Offset(size.width * 0.62, size.height),
        street,
      );

    final green = Paint()..color = AppColors.success;
    final orange = Paint()..color = AppColors.warning;
    final red = Paint()..color = AppColors.danger;
    final shadow = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    void marker(Offset center, double radius, Paint color) {
      canvas
        ..drawCircle(center.translate(0, 2), radius, shadow)
        ..drawCircle(center, radius, color)
        ..drawCircle(center, radius * 0.36, Paint()..color = Colors.white);
    }

    marker(Offset(size.width * 0.26, size.height * 0.66), 11, green);
    marker(Offset(size.width * 0.58, size.height * 0.48), 12, orange);
    marker(Offset(size.width * 0.80, size.height * 0.72), 12, red);
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => false;
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
