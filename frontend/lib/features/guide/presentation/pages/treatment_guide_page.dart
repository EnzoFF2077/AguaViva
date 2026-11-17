import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

const _cardColor = Color(0xFFEEF3FA);
const _borderColor = Color(0xFFD0DEE9);

const _titleStyle = TextStyle(
  color: AppColors.text,
  fontSize: 17,
  fontWeight: FontWeight.w700,
);
const _mutedStyle = TextStyle(
  color: AppColors.muted,
  fontSize: 14,
  height: 1.35,
);

/// Guia de tratamento do protótipo: metodos de Fervura e Cloracao.
class TreatmentGuidePage extends StatefulWidget {
  const TreatmentGuidePage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<TreatmentGuidePage> createState() => _TreatmentGuidePageState();
}

class _TreatmentGuidePageState extends State<TreatmentGuidePage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          tooltip: 'Voltar',
          onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: const Text('Como tratar a água'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          Text(
            'Enquanto a vigilância não responde, trate a água antes de beber '
            'ou cozinhar.',
            style: _mutedStyle,
          ),
          const SizedBox(height: 18),
          _MethodSelector(
            selected: _selected,
            onChanged: (value) => setState(() => _selected = value),
          ),
          const SizedBox(height: 18),
          if (_selected == 0)
            const _Steps(
              steps: [
                _Step(
                  'Coe a água em um pano limpo.',
                  Icons.filter_alt_outlined,
                ),
                _Step(
                  'Ferva por 1 minuto, contando das primeiras bolhas.',
                  Icons.soup_kitchen_outlined,
                ),
                _Step(
                  'Deixe esfriar tampada e guarde em vasilha limpa.',
                  Icons.inventory_2_outlined,
                ),
              ],
            )
          else
            const _Steps(
              steps: [
                _Step(
                  'Pingue 2 gotas de água sanitária para cada 1 litro.',
                  Icons.medication_outlined,
                ),
                _Step('Misture bem e espere 30 minutos.', Icons.schedule),
                _Step(
                  'Só depois disso beba ou use para cozinhar.',
                  Icons.local_drink_outlined,
                ),
              ],
            ),
          const SizedBox(height: 8),
          const Text(
            'Orientações baseadas em materiais da OMS e da FUNASA.',
            style: _mutedStyle,
          ),
        ],
      ),
    );
  }
}

class _MethodSelector extends StatelessWidget {
  const _MethodSelector({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Fervura', 'Cloração'];
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: Semantics(
                button: true,
                selected: selected == index,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(index),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected == index ? AppColors.primary : null,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        color: selected == index
                            ? Colors.white
                            : AppColors.muted,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Step {
  const _Step(this.text, this.icon);

  final String text;
  final IconData icon;
}

class _Steps extends StatelessWidget {
  const _Steps({required this.steps});

  final List<_Step> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _StepCard(number: index + 1, step: steps[index]),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.step});

  final int number;
  final _Step step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: Text(
              '$number',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.text, style: _titleStyle),
                const SizedBox(height: 10),
                Icon(step.icon, color: AppColors.primary, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
