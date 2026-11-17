import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/water_report.dart';
import '../controllers/report_controller.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({
    super.key,
    required this.controller,
    this.onOpenProfile,
  });

  final ReportController controller;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas notificações'),
        actions: [
          IconButton(
            tooltip: 'Tentar enviar pendências',
            onPressed: controller.retryPendingUploads,
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: Column(
        children: [
          if (onOpenProfile != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.surfaceSoft,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                title: const Text('Meu Perfil'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpenProfile,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFD9E5EE)),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<WaterReport>>(
              stream: controller.reports,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const _MessageState(
                    icon: Icons.cloud_off,
                    title: 'Não foi possível carregar agora',
                    message: 'Confira a conexão e tente novamente.',
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reports = snapshot.data!;
                if (reports.isEmpty) {
                  return const _MessageState(
                    icon: Icons.inbox_outlined,
                    title: 'Nenhum alerta registrado',
                    message:
                        'Os alertas feitos neste aparelho aparecerão aqui.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.retryPendingUploads,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return _PendingBanner(count: reports.length);
                      }
                      return _ReportCard(report: reports[index - 1]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD0DEE9)),
      ),
      child: Text(
        count == 1
            ? '1 notificação guardada no aparelho. Ela será enviada quando '
                  'houver internet.'
            : '$count notificações guardadas no aparelho. Elas serão enviadas '
                  'quando houver internet.',
        style: const TextStyle(color: AppColors.muted),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final WaterReport report;

  @override
  Widget build(BuildContext context) {
    final color = switch (report.status) {
      ReportStatus.resolved => AppColors.success,
      ReportStatus.underReview => AppColors.warning,
      ReportStatus.submitted => AppColors.primary,
      _ => AppColors.warning,
    };
    final date = report.createdAt;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: .35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.sourceName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                      ),
                    ],
                  ),
                ),
                _StatusBadge(label: report.status.label, color: color),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '${report.sourceType.label} • Água ${report.waterColor.label.toLowerCase()}${report.hasStrongOdor ? ' • cheiro forte' : ''}',
            ),
            if (report.hasPendingWrites) ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text('Alterações aguardando conexão'),
                ],
              ),
            ],
            if (report.responseMessage case final response?) ...[
              const Divider(height: 24),
              Text(
                'Vigilância Sanitária',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(response),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.primary),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
