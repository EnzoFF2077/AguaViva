import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onCreateReport});

  final VoidCallback onCreateReport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ÁguaViva'),
            Text(
              'Cuidar da água começa com você.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 42,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A água está estranha?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tire uma foto, responda perguntas simples e marque o local. Você não precisa se identificar.',
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: onCreateReport,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Avisar sobre a água'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _InfoCard(
              icon: Icons.shield_outlined,
              title: 'Aviso anônimo',
              text: 'Não pedimos nome, e-mail ou telefone.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.cloud_done_outlined,
              title: 'Funciona sem sinal',
              text: 'O alerta fica guardado e o envio da foto é tentado quando a conexão voltar.',
            ),
            const SizedBox(height: 12),
            const _InfoCard(
              icon: Icons.info_outline,
              title: 'A aparência não confirma segurança',
              text: 'Água transparente também pode estar contaminada. Consulte sempre o guia de tratamento.',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFD9E5EE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
