import 'package:flutter/material.dart';

import '../features/guide/presentation/pages/treatment_guide_page.dart';
import 'theme/app_theme.dart';

/// Estado de fallback do orçamento de inicialização.
///
/// Não importa Firebase: o guia de tratamento fica disponível no dispositivo e
/// mantém o aplicativo útil mesmo quando a conexão demora mais que o limite.
class OfflineStartupPage extends StatelessWidget {
  const OfflineStartupPage({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ÁguaViva · modo básico',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A conexão está demorando. Você já pode consultar como '
                    'tratar a água; as notificações voltam assim que o '
                    'aplicativo inicializar.',
                  ),
                ],
              ),
            ),
            const LinearProgressIndicator(minHeight: 3),
            const Expanded(child: TreatmentGuidePage()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
