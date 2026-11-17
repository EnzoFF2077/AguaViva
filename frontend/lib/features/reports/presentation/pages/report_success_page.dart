import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Confirmacao exibida apos o envio do alerta, conforme o prototipo.
///
/// O resultado do pop indica se o usuario quer ver suas notificacoes:
/// `true` abre a aba "Minhas", `false` volta para o inicio.
class ReportSuccessPage extends StatelessWidget {
  const ReportSuccessPage({
    super.key,
    required this.reportId,
    this.waitingInternet = false,
  });

  final String reportId;
  final bool waitingInternet;

  /// Numero amigavel derivado do identificador do alerta.
  static String alertNumber(String id) {
    final digits = id.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '2481';
    return digits.length > 4
        ? digits.substring(digits.length - 4)
        : digits.padLeft(4, '0');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (_, _) => Navigator.of(context).pop(false),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 88,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Alerta enviado',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Seu alerta foi enviado sem o seu nome. A Vigilância '
                    'Sanitária vai analisar e responder aqui no aplicativo.',
                    textAlign: TextAlign.center,
                  ),
                  if (waitingInternet) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Seu alerta será enviado assim que houver internet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.warning),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD0DEE9)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Número do seu alerta',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '#${alertNumber(reportId)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ver minhas notificações'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Voltar ao início',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
