import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class TreatmentGuidePage extends StatelessWidget {
  const TreatmentGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Como tratar a água'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFCEE5FA),
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Fervura'),
              Tab(text: 'Cloração'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_BoilingGuide(), _ChlorinationGuide()],
        ),
      ),
    );
  }
}

class _BoilingGuide extends StatelessWidget {
  const _BoilingGuide();

  @override
  Widget build(BuildContext context) {
    return const _GuideList(
      intro: 'Na falta de água potável, siga estes passos:',
      steps: [
        _GuideStep(
          icon: Icons.filter_alt_outlined,
          title: 'Prepare e filtre',
          text: 'Lave as mãos. Coe a água com filtro ou pano limpo.',
        ),
        _GuideStep(
          icon: Icons.soup_kitchen_outlined,
          title: 'Ferva por 5 minutos',
          text: 'Conte o tempo depois que a água começar a ferver.',
        ),
        _GuideStep(
          icon: Icons.ac_unit,
          title: 'Espere esfriar',
          text: 'Mantenha o recipiente tampado enquanto a água esfria.',
        ),
        _GuideStep(
          icon: Icons.inventory_2_outlined,
          title: 'Guarde com cuidado',
          text: 'Use recipiente limpo, fechado e exclusivo para água.',
        ),
      ],
    );
  }
}

class _ChlorinationGuide extends StatelessWidget {
  const _ChlorinationGuide();

  @override
  Widget build(BuildContext context) {
    return const _GuideList(
      intro: 'Use somente hipoclorito fornecido ou recomendado pela autoridade de saúde.',
      steps: [
        _GuideStep(
          icon: Icons.verified_outlined,
          title: 'Confira o produto',
          text: 'A dosagem muda conforme a concentração. Leia o rótulo antes de usar.',
        ),
        _GuideStep(
          icon: Icons.water_drop_outlined,
          title: 'Siga a dose do rótulo',
          text: 'Não aumente a quantidade e não misture com outros produtos.',
        ),
        _GuideStep(
          icon: Icons.timer_outlined,
          title: 'Aguarde o tempo indicado',
          text: 'Mantenha a água tampada durante o período de ação.',
        ),
        _GuideStep(
          icon: Icons.health_and_safety_outlined,
          title: 'Em caso de dúvida',
          text: 'Procure o agente de saúde ou a Vigilância Sanitária.',
        ),
      ],
    );
  }
}

class _GuideList extends StatelessWidget {
  const _GuideList({required this.intro, required this.steps});
  final String intro;
  final List<_GuideStep> steps;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.offline_bolt_outlined, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(child: Text('$intro\nDisponível mesmo sem internet.')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < steps.length; index++)
          _StepCard(number: index + 1, step: steps[index]),
        const SizedBox(height: 8),
        const Text(
          'Orientação educativa. Em surtos, enchentes ou orientações locais, siga as determinações da autoridade de saúde.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _GuideStep {
  const _GuideStep({
    required this.icon,
    required this.title,
    required this.text,
  });
  final IconData icon;
  final String title;
  final String text;
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.step});
  final int number;
  final _GuideStep step;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFD9E5EE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: Text('$number'),
            ),
            const SizedBox(width: 12),
            Icon(step.icon, color: AppColors.primary, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(step.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
